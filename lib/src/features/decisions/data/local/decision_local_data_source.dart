import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';

/// Storage on the device, with no rules of its own (those live in the
/// repository). Two implementations: Isar on phones, and an in-memory one for
/// the web preview, where Isar can't run. Both must pass
/// test/features/decisions/decision_local_data_source_contract.dart.
abstract class DecisionLocalDataSource {
  /// The user's decisions without soft-deleted ones, most recently updated first.
  Stream<List<Decision>> watchDecisions(String userId);
  Stream<Decision?> watchDecision(int localId);
  Future<Decision?> getDecision(int localId);

  /// Inserts (when localId is null) or replaces; returns it with its localId.
  Future<Decision> putDecision(Decision decision);

  /// Removes the decision with its evaluation and insights.
  Future<void> deleteDecisionPermanently(int localId);

  Future<Evaluation?> getEvaluation(int decisionLocalId);
  Stream<Evaluation?> watchEvaluation(int decisionLocalId);
  Future<Evaluation> putEvaluation(Evaluation evaluation);

  /// Newest request first.
  Stream<List<AiInsight>> watchInsights(int decisionLocalId);
  Future<List<AiInsight>> getInsights(int decisionLocalId, TriggerContext trigger);
  Future<AiInsight> putInsight(AiInsight insight);

  /// The user's tags except those waiting to be deleted, sorted by name.
  Stream<List<Tag>> watchTags(String userId);

  /// All the user's tags, including those waiting to be deleted.
  Future<List<Tag>> getTags(String userId);
  Future<Tag?> getTag(int localId);
  Future<Tag> putTag(Tag tag);
  Future<void> deleteTagPermanently(int localId);
}
