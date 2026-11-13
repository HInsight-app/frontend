import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Remembers, per user, where the next pull starts: the largest
/// server_updated_at the last one saw.
class PullCursorStore {
  const PullCursorStore(this._storage);

  final FlutterSecureStorage _storage;

  static String _key(String userId) => 'pull_cursor_$userId';

  Future<DateTime?> read(String userId) async {
    final saved = await _storage.read(key: _key(userId));
    return saved == null ? null : DateTime.tryParse(saved);
  }

  Future<void> write(String userId, DateTime cursor) => _storage.write(
      key: _key(userId), value: cursor.toUtc().toIso8601String());
}
