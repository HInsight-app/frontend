import '../entities/sync_report.dart';

/// Sends the changes saved on the device to the server (paper III-F): new
/// records are created there, edits are sent with their updated_at and the
/// newer copy wins a conflict, and deletions are passed on before the record
/// is removed from the device.
abstract class SyncRepository {
  /// Sends every waiting change of the signed-in user: tags first, then
  /// decisions, then evaluations (a child needs its parent's server id).
  /// Never throws for a failed request; the report says what happened.
  Future<SyncReport> syncPendingChanges();

  /// How many changes are waiting to be sent. Re-emits on every change.
  Stream<int> watchPendingChanges();
}
