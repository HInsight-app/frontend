import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the server could be reached the last time the app tried.
enum ConnectionStatus { unknown, online, offline }

/// Fed by every request: ConnectivityInterceptor for calls through Dio, and
/// the sync for its own results. The sync starts again when this changes
/// from offline to online (paper III-F, "Deteksi Koneksi").
final connectionStatusProvider =
    NotifierProvider<ConnectionStatusNotifier, ConnectionStatus>(
  ConnectionStatusNotifier.new,
);

class ConnectionStatusNotifier extends Notifier<ConnectionStatus> {
  @override
  ConnectionStatus build() => ConnectionStatus.unknown;

  /// The server answered (with any status code).
  void reportOnline() => state = ConnectionStatus.online;

  /// The server couldn't be reached or didn't answer in time.
  void reportOffline() => state = ConnectionStatus.offline;
}
