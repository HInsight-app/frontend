import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/connection_status.dart';
import '../../../core/routing/auth_redirect_enabled.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../decisions_providers.dart';
import '../domain/entities/sync_report.dart';
import '../domain/usecases/decision_usecases.dart';

/// Where the background sync stands, for the sync banner.
class SyncState {
  const SyncState({
    this.pending = 0,
    this.syncing = false,
    this.offline = false,
    this.lastReport,
    this.error,
  });

  /// Changes saved on the device that the server doesn't have yet.
  final int pending;
  final bool syncing;

  /// The server couldn't be reached the last time the app tried.
  final bool offline;

  final SyncReport? lastReport;

  /// An unexpected error from the last sync (a bug, not a failed request).
  final String? error;

  SyncState copyWith({
    int? pending,
    bool? syncing,
    bool? offline,
    SyncReport? lastReport,
    String? error,
    bool clearError = false,
    bool clearReport = false,
  }) =>
      SyncState(
        pending: pending ?? this.pending,
        syncing: syncing ?? this.syncing,
        offline: offline ?? this.offline,
        lastReport: clearReport ? null : lastReport ?? this.lastReport,
        error: clearError ? null : error ?? this.error,
      );
}

/// How long the sync waits. Tests make these short.
class SyncTiming {
  const SyncTiming({
    this.afterChange = const Duration(seconds: 2),
    this.firstRetry = const Duration(seconds: 15),
    this.maxRetry = const Duration(minutes: 5),
  });

  /// After a change, so a burst of edits is sent together.
  final Duration afterChange;

  /// After a failed sync; doubles after each failure up to [maxRetry].
  final Duration firstRetry;
  final Duration maxRetry;
}

final syncTimingProvider = Provider<SyncTiming>((ref) => const SyncTiming());

/// Whether the sync runs by itself. Widget tests that aren't about syncing
/// turn it off, because its timers would outlive them.
final autoSyncProvider = Provider<bool>((ref) => true);

/// Syncing needs a signed-in student; the web preview (login skipped) syncs
/// with the fake server.
final syncEnabledProvider = Provider<bool>(
  (ref) =>
      ref.watch(authControllerProvider).valueOrNull != null ||
      !ref.watch(authRedirectEnabledProvider),
);

/// How many changes wait to be synced.
final pendingChangesProvider = StreamProvider<int>(
  (ref) => ref.watch(syncRepositoryProvider).watchPendingChanges(),
);

final syncControllerProvider =
    NotifierProvider<SyncController, SyncState>(SyncController.new);

/// Runs the background sync (paper III-F). It syncs:
/// - when the app starts or the student signs in;
/// - shortly after a change is saved;
/// - when the server can be reached again ("Deteksi Koneksi": the Dio
///   interceptor reports every call, see ConnectivityInterceptor);
/// - when the app comes back to the foreground;
/// - after a failure, again and again with growing pauses.
class SyncController extends Notifier<SyncState> {
  Timer? _timer;
  Duration? _lastRetry;
  bool _running = false;
  bool _runAgain = false;
  int _followUps = 0;

  // Bumped by every build, i.e. when the user changes; a sync that finishes
  // after that belongs to the previous user and is ignored.
  int _generation = 0;

  @override
  SyncState build() {
    final generation = ++_generation;
    _timer?.cancel();
    _timer = null;
    _lastRetry = null;
    _running = false;
    _runAgain = false;
    _followUps = 0;
    ref.onDispose(() {
      if (generation == _generation) _timer?.cancel();
    });

    if (!ref.watch(syncEnabledProvider)) return const SyncState();
    // Rebuild (and so start over) when the user, store or server changes.
    ref.watch(syncRepositoryProvider);
    final auto = ref.watch(autoSyncProvider);

    ref.listen(pendingChangesProvider, (previous, next) {
      final count = next.valueOrNull;
      if (count == null) return;
      final before = previous?.valueOrNull;
      state = state.copyWith(pending: count);
      // The first count isn't a change; the sync at start covers it.
      if (!auto || before == null || count <= before) return;
      if (state.offline) {
        // Retry (with its pauses) rather than wait for a timeout per edit.
        if (_timer == null) _scheduleRetry();
      } else {
        _schedule(ref.read(syncTimingProvider).afterChange);
      }
    });

    ref.listen(connectionStatusProvider, (previous, next) {
      state = state.copyWith(offline: next == ConnectionStatus.offline);
      if (auto &&
          previous == ConnectionStatus.offline &&
          next == ConnectionStatus.online) {
        _lastRetry = null;
        _schedule(Duration.zero); // Back online
      }
    });

    if (auto) {
      final lifecycle =
          AppLifecycleListener(onResume: () => _schedule(Duration.zero));
      ref.onDispose(lifecycle.dispose);
      _schedule(Duration.zero); // At start and after signing in
    }

    return SyncState(
      pending: ref.read(pendingChangesProvider).valueOrNull ?? 0,
      offline: ref.read(connectionStatusProvider) == ConnectionStatus.offline,
    );
  }

  /// Syncs now, e.g. from the banner's "Try again".
  Future<void> syncNow() {
    _lastRetry = null;
    return _run();
  }

  /// Hides the note about server copies that replaced the device's.
  void dismissReport() => state = state.copyWith(clearReport: true);

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _run);
  }

  /// Waits [SyncTiming.firstRetry], then twice as long after each failure,
  /// up to [SyncTiming.maxRetry].
  void _scheduleRetry() {
    final timing = ref.read(syncTimingProvider);
    final previous = _lastRetry;
    final next = previous == null ? timing.firstRetry : previous * 2;
    _lastRetry = next > timing.maxRetry ? timing.maxRetry : next;
    _schedule(_lastRetry!);
  }

  Future<void> _run() async {
    _timer?.cancel();
    _timer = null;
    if (!ref.read(syncEnabledProvider)) return;
    if (_running) {
      _runAgain = true; // Changes made during this sync go in the next one
      return;
    }

    final generation = _generation;
    _running = true;
    state = state.copyWith(syncing: true);
    SyncReport? report;
    Object? error;
    try {
      report = await SyncPendingChangesUseCase(ref.read(syncRepositoryProvider))
          .execute();
    } catch (e) {
      error = e;
    }
    if (generation != _generation) return; // The user changed meanwhile
    _running = false;

    final connection = ref.read(connectionStatusProvider.notifier);
    if (report != null) {
      if (report.offline) {
        connection.reportOffline();
      } else if (report.reachedServer) {
        connection.reportOnline();
      }
    }
    state = state.copyWith(
      syncing: false,
      pending: report?.remaining,
      lastReport: report,
      error: error?.toString(),
      clearError: error == null,
    );

    if (_runAgain) {
      _runAgain = false;
      _schedule(Duration.zero);
    } else if (error != null || report!.shouldRetry) {
      _followUps = 0;
      _scheduleRetry();
    } else {
      _lastRetry = null;
      // Something changed during the sync (e.g. an edit while a decision was
      // being sent): send it too, but don't loop forever.
      if (report.remaining > 0 && _followUps++ < 3) {
        _schedule(Duration.zero);
      } else {
        _followUps = 0;
      }
    }
  }
}
