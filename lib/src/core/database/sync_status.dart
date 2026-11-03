/// Sync state of a locally cached record, stored on every user-editable Isar
/// collection. On reconnect, the repository pushes every record that isn't
/// [synced].
enum SyncStatus {
  /// Created offline, not yet pushed to the server.
  pendingCreate,

  /// Edited offline, server not yet updated.
  pendingUpdate,

  /// Soft-deleted offline, server not yet notified.
  pendingDelete,

  /// In sync with PostgreSQL.
  synced,
}
