import '../../../tags/domain/entities/tag.dart';
import '../entities/ai_insight.dart';
import '../entities/decision.dart';
import '../entities/decision_enums.dart';
import '../entities/evaluation.dart';

/// The decision flow from the paper (III-F): create a decision with options,
/// ask the AI to flag biases, commit, then evaluate later.
///
/// Everything is saved on the device first and works offline, except
/// requesting an AI insight, which needs the server. Broken rules throw a
/// DecisionException; failed server calls throw an ApiException.
abstract class DecisionRepository {
  /// The signed-in user's decisions, newest first, without deleted ones.
  /// [search] matches the title, context and option titles.
  Stream<List<Decision>> watchDecisions({DecisionStatus? status, String? search});

  Stream<Decision?> watchDecision(int localId);

  Stream<Evaluation?> watchEvaluation(int decisionLocalId);

  /// All insights for a decision, newest first.
  Stream<List<AiInsight>> watchInsights(int decisionLocalId);

  Future<Decision> createDecision(DecisionDraft draft);

  /// Edits a decision that hasn't been committed yet.
  Future<Decision> updateDecision(int localId, DecisionDraft draft);

  Future<void> deleteDecision(int localId);

  /// Records the chosen option; the status becomes decided.
  Future<Decision> commitDecision(
    int localId, {
    required String chosenOptionKey,
    String? commitmentNote,
  });

  /// Records the look back at a committed decision; the status becomes
  /// evaluated. Only one evaluation per decision.
  Future<Evaluation> evaluateDecision(
    int localId, {
    required int satisfactionAfter,
    int? confidenceAfter,
    String? hindsightNotes,
  });

  /// Asks the AI to check the decision: before committing ([TriggerContext.preDecision])
  /// or after evaluating ([TriggerContext.postEvaluation]). Needs a connection;
  /// the decision is sent to the server first if it hasn't been yet.
  Future<AiInsight> requestInsight(int localId, TriggerContext trigger);

  Stream<List<Tag>> watchTags();

  Future<Tag> createTag(String name, {String? colorHex});

  Future<void> deleteTag(int localId);
}
