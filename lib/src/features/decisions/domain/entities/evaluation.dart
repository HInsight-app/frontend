import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/sync_status.dart';

part 'evaluation.freezed.dart';

/// The student's look back at a committed decision (one per decision).
/// Mirrors EVALUATIONS.
@freezed
class Evaluation with _$Evaluation {
  const factory Evaluation({
    int? localId,
    String? serverId,
    required int decisionLocalId,
    String? decisionServerId,
    int? satisfactionAfter, // 1–100
    int? confidenceAfter, // 1–100, compared with Decision.confidenceBefore
    String? hindsightNotes,
    required DateTime createdAt,
    @Default(SyncStatus.pendingCreate) SyncStatus syncStatus,
  }) = _Evaluation;
}
