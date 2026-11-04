import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/sync_status.dart';
import 'decision_enums.dart';

part 'decision.freezed.dart';

/// A decision the student is making, with its options and (once committed)
/// its outcome. Mirrors DECISIONS, OPTIONS and DECISION_OUTCOMES.
@freezed
class Decision with _$Decision {
  const Decision._();

  const factory Decision({
    int? localId, // Null until first saved on the device
    String? serverId, // Null until synced
    required String userId,
    required String title,
    String? context,
    int? confidenceBefore, // 1–100
    DateTime? scheduledReviewDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(<DecisionOption>[]) List<DecisionOption> options,
    DecisionOutcome? outcome,
    @Default(<int>[]) List<int> tagLocalIds,
    @Default(DecisionStatus.pending) DecisionStatus status,
    @Default(SyncStatus.pendingCreate) SyncStatus syncStatus,
  }) = _Decision;

  /// The option the student committed to, or null before committing.
  DecisionOption? get chosenOption {
    final key = outcome?.chosenOptionKey;
    if (key == null) return null;
    for (final option in options) {
      if (option.key == key) return option;
    }
    return null;
  }
}

@freezed
class DecisionOption with _$DecisionOption {
  const factory DecisionOption({
    required String key, // Client-made UUID, stable before sync
    String? serverId,
    required String title,
    @Default(<String>[]) List<String> pros,
    @Default(<String>[]) List<String> cons,
    required DateTime createdAt,
  }) = _DecisionOption;
}

@freezed
class DecisionOutcome with _$DecisionOutcome {
  const factory DecisionOutcome({
    required String chosenOptionKey,
    String? commitmentNote,
    required DateTime decidedAt,
  }) = _DecisionOutcome;
}

/// What the student fills in when creating or editing a decision.
@freezed
class DecisionDraft with _$DecisionDraft {
  const factory DecisionDraft({
    required String title,
    String? context,
    int? confidenceBefore,
    DateTime? scheduledReviewDate,
    @Default(<OptionDraft>[]) List<OptionDraft> options,
    @Default(<int>[]) List<int> tagLocalIds,
  }) = _DecisionDraft;
}

@freezed
class OptionDraft with _$OptionDraft {
  const factory OptionDraft({
    String? key, // Set when editing an existing option, so it keeps its id
    required String title,
    @Default(<String>[]) List<String> pros,
    @Default(<String>[]) List<String> cons,
  }) = _OptionDraft;
}
