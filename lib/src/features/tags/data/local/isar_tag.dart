import 'package:isar/isar.dart';

import '../../../../core/database/sync_status.dart';

part 'isar_tag.g.dart';

/// Mirrors TAGS. Tags can be created and deleted offline; renaming needs a
/// connection because the server has no updated_at to resolve conflicts.
@collection
class IsarTag {
  Id localId = Isar.autoIncrement;

  // Not unique: Isar counts null as a value, so a unique index would allow only
  // one unsynced tag at a time. The server keeps UUIDs unique.
  @Index()
  String? serverId;

  @Index(unique: true, composite: [CompositeIndex('name')])
  late String userId; // UNIQUE(user_id, name)

  late String name;
  String? colorHex; // #RRGGBB, nullable like color_hex

  @Index()
  @Enumerated(EnumType.name)
  late SyncStatus syncStatus; // pendingCreate | pendingDelete | synced
}
