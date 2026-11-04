/// What one sync did: sending the changes saved on the device to the server
/// (paper III-F).
class SyncReport {
  const SyncReport({
    this.sent = 0,
    this.serverVersionsKept = const [],
    this.failures = const [],
    this.offline = false,
    this.stopMessage,
    this.reachedServer = false,
    this.remaining = 0,
  });

  /// Changes the server accepted.
  final int sent;

  /// Titles of decisions whose newer server copy replaced the one on the
  /// device (a 409 Conflict, resolved last-write-wins).
  final List<String> serverVersionsKept;

  /// One message per change that couldn't be sent; each stays saved on the
  /// device and is tried again next time.
  final List<String> failures;

  /// True when the sync stopped because the server couldn't be reached.
  final bool offline;

  /// Why the sync stopped early (offline, or the session ended), or null
  /// when it went through every change.
  final String? stopMessage;

  /// Whether the server answered at least one request.
  final bool reachedServer;

  /// Changes still waiting afterwards.
  final int remaining;

  /// Whether it is worth trying again later.
  bool get shouldRetry => stopMessage != null || failures.isNotEmpty;
}
