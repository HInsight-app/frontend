import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/sync_status.dart';

part 'tag.freezed.dart';

/// A label the student puts on decisions (e.g. Academic, Career). Names are
/// unique per user. Mirrors TAGS.
@freezed
class Tag with _$Tag {
  const factory Tag({
    int? localId,
    String? serverId,
    required String userId,
    required String name,
    String? colorHex, // #RRGGBB
    @Default(SyncStatus.pendingCreate) SyncStatus syncStatus,
  }) = _Tag;
}
