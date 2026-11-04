import 'dart:async';

import '../../../../core/database/sync_status.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/uuid.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/sync_report.dart';
import '../../domain/repositories/sync_repository.dart';
import '../local/decision_local_data_source.dart';
import '../remote/decision_remote_data_source.dart';

/// Sends the changes saved on the device to the server, as the paper
/// describes in III-F:
///
/// - pendingCreate: POST, then store the returned server ids and mark synced.
/// - pendingUpdate: PUT with the local updated_at. On 409 Conflict the
///   server's copy is newer, so it replaces the one on the device.
/// - pendingDelete: DELETE, then remove the record from the device.
///
/// The student may keep editing while a request is out, so after every
/// request the record is read again and a newer change is never overwritten.
class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl({
    required this.local,
    required this.remote,
    required this.userId,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final DecisionLocalDataSource local;
  final DecisionRemoteDataSource remote;
  final String userId;
  final DateTime Function() _now;

  // Two syncs at once could send the same new decision twice and create it
  // twice on the server, so they wait for each other. Null while idle, so no
  // finished future is kept around (a test's fake-time zone would hold on to
  // its callbacks).
  Future<void>? _busy;

  Future<T> _oneAtATime<T>(Future<T> Function() action) async {
    while (_busy != null) {
      await _busy;
    }
    final done = Completer<void>();
    _busy = done.future;
    try {
      return await action();
    } finally {
      _busy = null;
      done.complete();
    }
  }

  @override
  Stream<int> watchPendingChanges() => local.watchUnsyncedCount(userId);

  @override
  Future<SyncReport> syncPendingChanges() => _oneAtATime(_sync);

  /// For when the server says it has no record of a decision it gave an id
  /// to (e.g. its database was reset): marks the decision and its evaluation
  /// as new, so the next sync creates them again.
  Future<void> forgetServerCopy(int decisionLocalId) =>
      _oneAtATime(() => _forget(decisionLocalId));

  /// Applies a server copy that came back from a request outside a sync,
  /// e.g. an AI request for a decision deleted on another device.
  Future<void> applyServerCopy(int decisionLocalId, RemoteDecision serverCopy) =>
      _oneAtATime(() async {
        final d = await local.getDecision(decisionLocalId);
        if (d != null) await _keepServerVersion(d, serverCopy);
      });

  Future<SyncReport> _sync() async {
    final log = _Log();
    try {
      await _syncTags(log);
      await _syncDecisions(log);
      await _syncEvaluations(log);
    } on ApiException catch (e) {
      // Offline or signed out: every other request would fail the same way.
      return log.report(
        offline: e.isConnectionProblem,
        stopMessage: e.message,
        remaining: await _remaining(),
      );
    }
    return log.report(remaining: await _remaining());
  }

  Future<int> _remaining() => local.watchUnsyncedCount(userId).first;

  /// Sends one record. A connection problem or an ended session (401) stops
  /// the whole sync; any other failure is noted and the sync moves on.
  Future<void> _attempt(_Log log, String what, Future<void> Function() send) async {
    try {
      await send();
    } on ApiException catch (e) {
      if (e.isConnectionProblem || e.statusCode == 401) rethrow;
      log.reachedServer = true;
      log.failures.add('$what: ${e.message}');
    } on _NotReady catch (e) {
      log.failures.add('$what ${e.message}');
    }
  }

  // --- Tags: first, because decisions refer to them by server id ---

  Future<void> _syncTags(_Log log) async {
    for (final tag in await local.getTags(userId)) {
      if (tag.syncStatus == SyncStatus.synced) continue;
      await _attempt(log, 'Tag "${tag.name}"', () => _pushTag(tag, log));
    }
  }

  Future<void> _pushTag(Tag tag, _Log log) async {
    if (tag.syncStatus == SyncStatus.pendingDelete) {
      if (tag.serverId != null) {
        await _ignoreNotFound(() => remote.deleteTag(tag.serverId!));
        log.accepted();
      }
      final latest = await local.getTag(tag.localId!);
      if (latest == null) return;
      if (latest.syncStatus == SyncStatus.pendingDelete) {
        await local.deleteTagPermanently(tag.localId!);
      } else {
        // Brought back on the device while the server deleted it: create it
        // again.
        await local.putTag(
            latest.copyWith(serverId: null, syncStatus: SyncStatus.pendingCreate));
      }
      return;
    }

    // Tags are never edited, so anything else just needs a server id.
    if (tag.serverId != null) {
      await local.putTag(tag.copyWith(syncStatus: SyncStatus.synced));
      return;
    }
    final id = await remote.createTag(tag);
    log.accepted();
    final latest = await local.getTag(tag.localId!);
    if (latest == null) {
      // Deleted on the device while it was being sent, so delete it on the
      // server too. If that fails, an unused tag stays there; no harm done.
      try {
        await remote.deleteTag(id);
      } on ApiException catch (_) {
        // Best effort only.
      }
      return;
    }
    await local.putTag(latest.copyWith(
      serverId: id,
      syncStatus: latest.syncStatus == SyncStatus.pendingDelete
          ? SyncStatus.pendingDelete
          : SyncStatus.synced,
    ));
  }

  // --- Decisions, with their options and outcome ---

  Future<void> _syncDecisions(_Log log) async {
    final waiting = await local.getUnsyncedDecisions(userId)
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    for (final stale in waiting) {
      // Read it again: an earlier request in this sync took time.
      final d = await local.getDecision(stale.localId!);
      if (d == null || d.syncStatus == SyncStatus.synced) continue;
      await _attempt(log, '"${d.title}"', () async {
        try {
          await _pushDecision(d, log);
        } on DecisionConflictException catch (conflict) {
          log.reachedServer = true;
          await _keepServerVersion(d, conflict.serverCopy);
          log.serverVersionsKept.add(d.title);
        }
      });
    }
  }

  Future<void> _pushDecision(Decision d, _Log log) async {
    if (d.syncStatus == SyncStatus.pendingDelete) {
      if (d.serverId != null) {
        // 404: the server doesn't have it either, which is what we want.
        await _ignoreNotFound(
            () => remote.deleteDecision(d.serverId!, updatedAt: d.updatedAt));
        log.accepted();
      }
      // Nothing can bring back a deleted decision on the device, so it can go.
      await local.deleteDecisionPermanently(d.localId!);
      return;
    }

    final tagIds = await _tagServerIds(d);
    final RemoteDecisionIds ids;
    if (d.serverId == null) {
      ids = await remote.createDecision(d, tagServerIds: tagIds);
    } else {
      try {
        ids = await remote.updateDecision(d, tagServerIds: tagIds);
      } on ApiException catch (e) {
        if (e.statusCode != 404) rethrow;
        // The server has no record of it (e.g. its database was reset, or
        // the fake server restarted): send it again as new.
        await _forget(d.localId!);
        final fresh = await local.getDecision(d.localId!);
        if (fresh != null && fresh.serverId == null) {
          await _pushDecision(fresh, log);
        }
        return;
      }
    }
    log.accepted();
    await _afterSent(d, ids);
  }

  /// The server ids of the decision's tags. Tags are synced first, so one
  /// without a server id failed to sync; the decision waits for it.
  Future<List<String>> _tagServerIds(Decision d) async {
    final ids = <String>[];
    for (final localId in d.tagLocalIds) {
      final tag = await local.getTag(localId);
      if (tag == null || tag.syncStatus == SyncStatus.pendingDelete) continue;
      if (tag.serverId == null) {
        throw const _NotReady('waits until its tags are synced.');
      }
      ids.add(tag.serverId!);
    }
    return ids;
  }

  /// Stores the server ids after a create or update, keeping any change the
  /// student made while the request was out.
  Future<void> _afterSent(Decision sent, RemoteDecisionIds ids) async {
    List<DecisionOption> withIds(List<DecisionOption> options) => [
          for (final o in options)
            o.copyWith(serverId: ids.optionIds[o.key] ?? o.serverId),
        ];

    final latest = await local.getDecision(sent.localId!);
    if (latest == null) {
      // A new decision deleted on the device while it was being created: the
      // delete removed it outright, but the server has it now. Keep a hidden
      // copy so the next sync deletes it there too.
      final now = _now();
      await local.putDecision(sent.copyWith(
        serverId: ids.id,
        options: withIds(sent.options),
        deletedAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.pendingDelete,
      ));
      return;
    }

    final SyncStatus status;
    if (latest.syncStatus == SyncStatus.pendingDelete) {
      status = SyncStatus.pendingDelete; // Deleted meanwhile: delete it there
    } else if (latest.updatedAt != sent.updatedAt) {
      status = SyncStatus.pendingUpdate; // Edited meanwhile: send that next
    } else {
      status = SyncStatus.synced;
    }
    await local.putDecision(latest.copyWith(
      serverId: ids.id,
      options: withIds(latest.options),
      syncStatus: status,
    ));
  }

  /// Resolves a 409 Conflict last-write-wins: the server's copy is newer, so
  /// it replaces the one on the device (paper III-F).
  Future<void> _keepServerVersion(Decision mine, RemoteDecision server) async {
    final latest = await local.getDecision(mine.localId!);
    if (latest == null) {
      if (server.deletedAt != null) return; // Deleted on both sides
      // Deleted on the device meanwhile: keep a hidden copy so the next sync
      // deletes it on the server too.
      final now = _now();
      await local.putDecision(mine.copyWith(
        serverId: server.id,
        deletedAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.pendingDelete,
      ));
      return;
    }
    if (latest.updatedAt != mine.updatedAt ||
        latest.syncStatus != mine.syncStatus) {
      // Changed again on the device while the request was out. That change
      // is newer than the server's, so send it next time instead.
      await local.putDecision(latest.copyWith(
        serverId: server.id,
        syncStatus: latest.syncStatus == SyncStatus.pendingCreate
            ? SyncStatus.pendingUpdate
            : latest.syncStatus,
      ));
      return;
    }
    if (server.deletedAt != null) {
      // Deleted on the server (e.g. on another device) after this change.
      await local.deleteDecisionPermanently(latest.localId!);
      return;
    }

    final options = [
      for (final o in server.options)
        DecisionOption(
          key: _keyFor(o, latest.options),
          serverId: o.id,
          title: o.title,
          pros: o.pros,
          cons: o.cons,
          createdAt: o.createdAt,
        ),
    ];

    DecisionOutcome? outcome;
    final serverOutcome = server.outcome;
    if (serverOutcome != null) {
      final chosen = options
          .where((o) => o.serverId == serverOutcome.chosenOptionId)
          .firstOrNull;
      if (chosen != null) {
        outcome = DecisionOutcome(
          chosenOptionKey: chosen.key,
          commitmentNote: serverOutcome.commitmentNote,
          decidedAt: serverOutcome.decidedAt,
        );
      }
    }

    var syncStatus = SyncStatus.synced;
    var updatedAt = server.updatedAt;
    final myChoice = latest.chosenOption;
    if (outcome == null && latest.outcome != null && myChoice != null) {
      // Committing is final (paper III-F), so a conflict never undoes a
      // commitment made on the device: keep it, with its chosen option, and
      // send it again as the newer change.
      var key = options
          .where((o) => o.title.toLowerCase() == myChoice.title.toLowerCase())
          .firstOrNull
          ?.key;
      if (key == null) {
        options.add(myChoice.copyWith(serverId: null));
        key = myChoice.key;
      }
      outcome = latest.outcome!.copyWith(chosenOptionKey: key);
      syncStatus = SyncStatus.pendingUpdate;
      final now = _now();
      // Later than the server's copy even if the phone's clock is behind.
      updatedAt = now.isAfter(server.updatedAt)
          ? now
          : server.updatedAt.add(const Duration(milliseconds: 1));
    }

    final tags = await local.getTags(userId);
    final evaluated =
        outcome != null && await local.getEvaluation(latest.localId!) != null;
    await local.putDecision(Decision(
      localId: latest.localId,
      serverId: server.id,
      userId: latest.userId,
      title: server.title,
      context: server.context,
      confidenceBefore: server.confidenceBefore,
      scheduledReviewDate: server.scheduledReviewDate,
      createdAt: server.createdAt,
      updatedAt: updatedAt,
      options: options,
      outcome: outcome,
      // Tags the device doesn't know yet are left out.
      tagLocalIds: [
        for (final id in server.tagIds)
          ...tags.where((t) => t.serverId == id).map((t) => t.localId!),
      ],
      status: outcome == null
          ? DecisionStatus.pending
          : evaluated
              ? DecisionStatus.evaluated
              : DecisionStatus.decided,
      syncStatus: syncStatus,
    ));
  }

  /// Keeps an option's local key (the outcome refers to it) when the server
  /// copy has the same option.
  static String _keyFor(RemoteOption option, List<DecisionOption> mine) =>
      mine.where((m) => m.serverId == option.id).firstOrNull?.key ??
      mine
          .where((m) =>
              m.serverId == null &&
              m.title.toLowerCase() == option.title.toLowerCase())
          .firstOrNull
          ?.key ??
      newUuidV4();

  // --- Evaluations: last, because they need their decision's server id ---

  Future<void> _syncEvaluations(_Log log) async {
    for (final e in await local.getUnsyncedEvaluations()) {
      final d = await local.getDecision(e.decisionLocalId);
      // Skip other users' evaluations, and those of deleted decisions:
      // deleting the decision on the server removes its evaluation too.
      if (d == null || d.userId != userId || d.deletedAt != null) continue;
      await _attempt(log, 'The evaluation of "${d.title}"', () async {
        if (d.serverId == null) {
          throw const _NotReady('waits until its decision is synced.');
        }
        try {
          final id = await remote.createEvaluation(d.serverId!, e);
          log.accepted();
          await local.putEvaluation(e.copyWith(
            serverId: id,
            decisionServerId: d.serverId,
            syncStatus: SyncStatus.synced,
          ));
        } on DecisionConflictException catch (conflict) {
          // Its decision was deleted on the server.
          log.reachedServer = true;
          await _keepServerVersion(d, conflict.serverCopy);
          log.serverVersionsKept.add(d.title);
        } on ApiException catch (error) {
          if (error.statusCode != 404) rethrow;
          // The server has no record of the decision: the next sync sends
          // both again as new.
          log.reachedServer = true;
          await _forget(d.localId!);
        }
      });
    }
  }

  // --- Helpers ---

  Future<void> _forget(int decisionLocalId) async {
    final d = await local.getDecision(decisionLocalId);
    if (d == null) return;
    await local.putDecision(d.copyWith(
      serverId: null,
      options: [for (final o in d.options) o.copyWith(serverId: null)],
      syncStatus: d.syncStatus == SyncStatus.pendingDelete
          ? SyncStatus.pendingDelete
          : SyncStatus.pendingCreate,
    ));
    final e = await local.getEvaluation(decisionLocalId);
    if (e != null) {
      await local.putEvaluation(e.copyWith(
        serverId: null,
        decisionServerId: null,
        syncStatus: SyncStatus.pendingCreate,
      ));
    }
  }

  static Future<void> _ignoreNotFound(Future<void> Function() request) async {
    try {
      await request();
    } on ApiException catch (e) {
      if (e.statusCode != 404) rethrow;
    }
  }
}

/// A record that can't be sent until another one is.
class _NotReady implements Exception {
  const _NotReady(this.message);

  final String message;
}

/// What happens during one sync, for its report.
class _Log {
  var sent = 0;
  var reachedServer = false;
  final serverVersionsKept = <String>[];
  final failures = <String>[];

  void accepted() {
    sent++;
    reachedServer = true;
  }

  SyncReport report({
    bool offline = false,
    String? stopMessage,
    required int remaining,
  }) =>
      SyncReport(
        sent: sent,
        serverVersionsKept: List.unmodifiable(serverVersionsKept),
        failures: List.unmodifiable(failures),
        offline: offline,
        stopMessage: stopMessage,
        reachedServer: reachedServer || (stopMessage != null && !offline),
        remaining: remaining,
      );
}
