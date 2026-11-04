import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';

/// The server ids given to a decision and its options, keyed by option key.
class RemoteDecisionIds {
  const RemoteDecisionIds({required this.id, required this.optionIds});

  final String id;
  final Map<String, String> optionIds;
}

/// A decision as the server stores it (DECISIONS with its OPTIONS,
/// DECISION_OUTCOMES and DECISION_TAGS). The app only receives one when the
/// server's copy wins a conflict (409).
class RemoteDecision {
  const RemoteDecision({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.context,
    this.confidenceBefore,
    this.scheduledReviewDate,
    this.deletedAt,
    this.options = const [],
    this.outcome,
    this.tagIds = const [],
  });

  final String id;
  final String title;
  final String? context;
  final int? confidenceBefore;
  final DateTime? scheduledReviewDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<RemoteOption> options;
  final RemoteOutcome? outcome;
  final List<String> tagIds;
}

class RemoteOption {
  const RemoteOption({
    required this.id,
    required this.title,
    required this.createdAt,
    this.pros = const [],
    this.cons = const [],
  });

  final String id;
  final String title;
  final List<String> pros;
  final List<String> cons;
  final DateTime createdAt;
}

class RemoteOutcome {
  const RemoteOutcome({
    required this.chosenOptionId,
    required this.decidedAt,
    this.commitmentNote,
  });

  final String chosenOptionId;
  final String? commitmentNote;
  final DateTime decidedAt;
}

/// The server refused a change because its copy is newer (409 Conflict,
/// paper III-F). The app replaces its own copy with [serverCopy].
class DecisionConflictException implements Exception {
  const DecisionConflictException(this.serverCopy);

  final RemoteDecision serverCopy;

  @override
  String toString() => 'The server has a newer version of this decision.';
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

/// The endpoints the app needs from the backend. As of 2026-11-04 the backend
/// has none of them (only a title-only POST /decisions, not even mounted), so
/// the app uses FakeDecisionRemoteDataSource. DioDecisionRemoteDataSource
/// calls the real ones; docs/SYNC_API.md describes each request and response.
///
/// Failures throw an ApiException; a 409 on a decision throws a
/// DecisionConflictException.
abstract class DecisionRemoteDataSource {
  /// POST /decisions. [tagServerIds] are the server ids of its tags.
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  });

  /// PUT /decisions/{id}: the whole decision, including its outcome once
  /// committed. The server keeps whichever copy has the later updated_at.
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  });

  /// DELETE /decisions/{id}, with the local [updatedAt] for the same check.
  Future<void> deleteDecision(String serverId, {required DateTime updatedAt});

  /// POST /decisions/{id}/evaluations. Returns the evaluation's server id,
  /// also when the server already had one (a retried request).
  Future<String> createEvaluation(String decisionServerId, Evaluation evaluation);

  /// POST /decisions/{id}/insights: runs the AI on the server's copy.
  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  );

  /// POST /tags. Returns the tag's server id, also when the user already has
  /// a tag with that name on the server.
  Future<String> createTag(Tag tag);

  /// DELETE /tags/{id}.
  Future<void> deleteTag(String serverId);
}
