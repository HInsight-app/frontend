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
/// DECISION_OUTCOMES, EVALUATIONS and DECISION_TAGS). The app receives one
/// when the server's copy wins a conflict (409) and when it pulls changes.
class RemoteDecision {
  const RemoteDecision({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.serverUpdatedAt,
    this.context,
    this.confidenceBefore,
    this.scheduledReviewDate,
    this.deletedAt,
    this.options = const [],
    this.outcome,
    this.evaluation,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String? context;
  final int? confidenceBefore;
  final DateTime? scheduledReviewDate;
  final DateTime createdAt;

  /// The device's time of the last edit, used for last-write-wins.
  final DateTime updatedAt;

  /// The server's time of its last change to the decision or anything in it.
  /// The largest one seen is where the next pull starts.
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  final List<RemoteOption> options;
  final RemoteOutcome? outcome;
  final RemoteEvaluation? evaluation;
  final List<RemoteTag> tags;
}

class RemoteTag {
  const RemoteTag({required this.id, required this.name, this.colorHex});

  final String id;
  final String name;
  final String? colorHex;
}

class RemoteEvaluation {
  const RemoteEvaluation({
    required this.id,
    required this.createdAt,
    this.satisfactionAfter,
    this.confidenceAfter,
    this.hindsightNotes,
  });

  final String id;
  final int? satisfactionAfter;
  final int? confidenceAfter;
  final String? hindsightNotes;
  final DateTime createdAt;
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

/// The backend's decision and tag endpoints, all POST except reads.
/// DioDecisionRemoteDataSource calls the real ones (DECISION_API=live in
/// .env); FakeDecisionRemoteDataSource stands in for them by default.
///
/// Failures throw an ApiException; a 409 on a decision throws a
/// DecisionConflictException.
abstract class DecisionRemoteDataSource {
  /// POST /decisions, with its outcome when it was committed before its
  /// first sync. [tagServerIds] are the server ids of its tags.
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  });

  /// POST /decisions/{id}/sync: the whole decision, including its outcome
  /// once committed. The server keeps whichever copy has the later
  /// updated_at.
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  });

  /// POST /decisions/{id}/delete, with the local [updatedAt] for the same
  /// check.
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

  /// POST /tags/{id}/delete.
  Future<void> deleteTag(String serverId);

  /// GET /decisions?updated_since=: the user's decisions the server changed
  /// at or after [since] (every one when null), deleted ones included.
  Future<List<RemoteDecision>> pullDecisions({DateTime? since});
}
