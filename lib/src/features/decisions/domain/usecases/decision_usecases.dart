import '../entities/ai_insight.dart';
import '../entities/decision.dart';
import '../entities/decision_enums.dart';
import '../entities/evaluation.dart';
import '../repositories/decision_repository.dart';

// One use case per step of the decision flow (paper III-F), like the auth
// feature's use cases. They are thin today; rules live in the repository so
// every caller gets them.

class WatchDecisionsUseCase {
  WatchDecisionsUseCase(this.repository);
  final DecisionRepository repository;

  Stream<List<Decision>> execute({DecisionStatus? status, String? search}) =>
      repository.watchDecisions(status: status, search: search);
}

class CreateDecisionUseCase {
  CreateDecisionUseCase(this.repository);
  final DecisionRepository repository;

  Future<Decision> execute(DecisionDraft draft) =>
      repository.createDecision(draft);
}

/// Also how options are added or changed before committing.
class UpdateDecisionUseCase {
  UpdateDecisionUseCase(this.repository);
  final DecisionRepository repository;

  Future<Decision> execute(int localId, DecisionDraft draft) =>
      repository.updateDecision(localId, draft);
}

class DeleteDecisionUseCase {
  DeleteDecisionUseCase(this.repository);
  final DecisionRepository repository;

  Future<void> execute(int localId) => repository.deleteDecision(localId);
}

class RequestInsightUseCase {
  RequestInsightUseCase(this.repository);
  final DecisionRepository repository;

  Future<AiInsight> execute(int localId, TriggerContext trigger) =>
      repository.requestInsight(localId, trigger);
}

class CommitDecisionUseCase {
  CommitDecisionUseCase(this.repository);
  final DecisionRepository repository;

  Future<Decision> execute(
    int localId, {
    required String chosenOptionKey,
    String? commitmentNote,
  }) =>
      repository.commitDecision(
        localId,
        chosenOptionKey: chosenOptionKey,
        commitmentNote: commitmentNote,
      );
}

class EvaluateDecisionUseCase {
  EvaluateDecisionUseCase(this.repository);
  final DecisionRepository repository;

  Future<Evaluation> execute(
    int localId, {
    required int satisfactionAfter,
    int? confidenceAfter,
    String? hindsightNotes,
  }) =>
      repository.evaluateDecision(
        localId,
        satisfactionAfter: satisfactionAfter,
        confidenceAfter: confidenceAfter,
        hindsightNotes: hindsightNotes,
      );
}
