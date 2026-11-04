import 'package:freezed_annotation/freezed_annotation.dart';

import 'decision_enums.dart';

part 'ai_insight.freezed.dart';

/// An AI check of a decision for cognitive biases. It flags possible biases;
/// it never decides for the student. Mirrors AI_INSIGHTS, plus the local
/// request [status] described in the paper.
@freezed
class AiInsight with _$AiInsight {
  const factory AiInsight({
    int? localId,
    String? serverId, // Null while processing
    required int decisionLocalId,
    required String decisionServerId,
    required TriggerContext triggerContext,
    required InsightStatus status,
    required DateTime requestedAt,
    // The fields below are filled in once status is complete.
    String? modelVersion,
    String? insightText,
    BiasType? primaryBias, // Null when no bias was found
    EmotionalTone? emotionalTone,
    RiskLevel? riskLevel,
    int? actionabilityScore, // 1–10
    String? suggestedAlternative,
    double? modelConfidence, // 0.0–1.0
    DateTime? generatedAt,
  }) = _AiInsight;
}
