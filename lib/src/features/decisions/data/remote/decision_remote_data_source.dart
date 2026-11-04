import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';

/// The server ids given to a decision and its options, keyed by option key.
class RemoteDecisionIds {
  const RemoteDecisionIds({required this.id, required this.optionIds});

  final String id;
  final Map<String, String> optionIds;
}

/// A finished AI insight as the server returns it (an AI_INSIGHTS row).
class RemoteInsight {
  const RemoteInsight({
    required this.serverId,
    required this.modelVersion,
    required this.insightText,
    required this.generatedAt,
    this.primaryBias,
    this.emotionalTone,
    this.riskLevel,
    this.actionabilityScore,
    this.suggestedAlternative,
    this.modelConfidence,
  });

  final String serverId;
  final String modelVersion;
  final String insightText;
  final DateTime generatedAt;
  final BiasType? primaryBias;
  final EmotionalTone? emotionalTone;
  final RiskLevel? riskLevel;
  final int? actionabilityScore;
  final String? suggestedAlternative;
  final double? modelConfidence;
}

/// The decision endpoints the app needs from the backend. As of 2026-11-04
/// the backend only has a title-only POST /decisions (not even mounted), so
/// the app uses FakeDecisionRemoteDataSource until these exist:
///
/// - POST   /decisions                      → create with options; returns ids
/// - PUT    /decisions/{id}                 → update, incl. outcome; 409 on conflict (paper III-F)
/// - DELETE /decisions/{id}
/// - POST   /decisions/{id}/evaluations
/// - POST   /decisions/{id}/insights        → {trigger_context}; runs Gemini
///
/// Failures throw an ApiException.
abstract class DecisionRemoteDataSource {
  Future<RemoteDecisionIds> createDecision(Decision decision);

  /// Sends the whole decision, including its outcome once committed.
  Future<RemoteDecisionIds> updateDecision(Decision decision);

  Future<void> deleteDecision(String serverId);

  /// Returns the evaluation's server id.
  Future<String> createEvaluation(String decisionServerId, Evaluation evaluation);

  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  );
}
