import 'package:isar/isar.dart';

import '../../../../core/database/sync_status.dart';

part 'isar_evaluation.g.dart';

/// Mirrors EVALUATIONS (one per decision). Create-only, so [syncStatus] is
/// only ever pendingCreate or synced.
@collection
class IsarEvaluation {
  Id localId = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId;

  @Index(unique: true)
  late int decisionLocalId; // References IsarDecision.localId, always present
  String? decisionServerId; // Filled once the parent decision has synced

  int? satisfactionAfter; // 1–100
  int? confidenceAfter; // 1–100, compared with confidenceBefore
  String? hindsightNotes;
  late DateTime createdAt;

  @Index()
  @Enumerated(EnumType.name)
  late SyncStatus syncStatus;
}
