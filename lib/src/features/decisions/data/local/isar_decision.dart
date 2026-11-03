import 'package:isar/isar.dart';

import '../../../../core/database/sync_status.dart';
import '../../domain/entities/decision_enums.dart';

part 'isar_decision.g.dart';

/// Local cache of a decision, mirroring the DECISIONS table. Its options and
/// outcome are embedded because they are always loaded with the decision.
@collection
class IsarDecision {
  Id localId = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId; // PostgreSQL UUID, null until synced

  @Index()
  late String userId;

  late String title;
  String? context;
  int? confidenceBefore; // 1–100, nullable like confidence_before
  DateTime? scheduledReviewDate; // Date only (DATE on the server)
  late DateTime createdAt;
  late DateTime updatedAt; // Used for last-write-wins conflict resolution
  DateTime? deletedAt; // Soft delete, mirrors deleted_at

  late List<IsarOption> options;
  IsarDecisionOutcome? outcome;

  // Replaces DECISION_TAGS; local ids so offline-created tags work too
  late List<int> tagLocalIds;

  // Local only. Derived: outcome == null → pending, evaluation exists →
  // evaluated, else decided. Never sent to the server.
  @Index()
  @Enumerated(EnumType.name)
  late DecisionStatus status;

  @Index()
  @Enumerated(EnumType.name)
  late SyncStatus syncStatus;
}

/// Mirrors OPTIONS. Never loaded independently of its decision.
@embedded
class IsarOption {
  late String localKey; // Client-generated UUID v4, stable before sync
  String? serverId; // PostgreSQL UUID, null until synced
  late String title; // Unique within its decision (UNIQUE(decision_id, title))
  String? pros;
  String? cons;
  late DateTime createdAt;
}

/// Mirrors DECISION_OUTCOMES (one per decision). Null until the user commits.
@embedded
class IsarDecisionOutcome {
  late String chosenOptionKey; // IsarOption.localKey; sent as chosen_option_id
  String? commitmentNote;
  late DateTime decidedAt;
}
