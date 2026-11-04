import 'dart:async';

import '../../../../core/database/sync_status.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'decision_local_data_source.dart';

/// Keeps everything in memory, so it is lost when the app closes. Used for
/// the web preview, where Isar can't run, and in tests.
class MemoryDecisionLocalDataSource implements DecisionLocalDataSource {
  final _decisions = <int, Decision>{};
  final _evaluations = <int, Evaluation>{};
  final _insights = <int, AiInsight>{};
  final _tags = <int, Tag>{};
  var _nextId = 1;

  // Fires after every write so the watch streams can re-emit.
  final _changes = StreamController<void>.broadcast();

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    await for (final _ in _changes.stream) {
      yield read();
    }
  }

  void _changed() => _changes.add(null);

  List<Decision> _decisionsOf(String userId) => _decisions.values
      .where((d) => d.userId == userId && d.deletedAt == null)
      .toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<AiInsight> _insightsOf(int decisionLocalId) => _insights.values
      .where((i) => i.decisionLocalId == decisionLocalId)
      .toList()
    ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

  @override
  Stream<List<Decision>> watchDecisions(String userId) =>
      _watch(() => _decisionsOf(userId));

  @override
  Stream<Decision?> watchDecision(int localId) =>
      _watch(() => _decisions[localId]);

  @override
  Future<Decision?> getDecision(int localId) async => _decisions[localId];

  @override
  Future<Decision> putDecision(Decision decision) async {
    final saved = decision.copyWith(localId: decision.localId ?? _nextId++);
    _decisions[saved.localId!] = saved;
    _changed();
    return saved;
  }

  @override
  Future<void> deleteDecisionPermanently(int localId) async {
    _decisions.remove(localId);
    _evaluations.removeWhere((_, e) => e.decisionLocalId == localId);
    _insights.removeWhere((_, i) => i.decisionLocalId == localId);
    _changed();
  }

  @override
  Future<Evaluation?> getEvaluation(int decisionLocalId) async =>
      _evaluationOf(decisionLocalId);

  Evaluation? _evaluationOf(int decisionLocalId) {
    for (final e in _evaluations.values) {
      if (e.decisionLocalId == decisionLocalId) return e;
    }
    return null;
  }

  @override
  Stream<Evaluation?> watchEvaluation(int decisionLocalId) =>
      _watch(() => _evaluationOf(decisionLocalId));

  @override
  Future<Evaluation> putEvaluation(Evaluation evaluation) async {
    final existing = _evaluationOf(evaluation.decisionLocalId);
    if (existing != null && existing.localId != evaluation.localId) {
      throw StateError('Decision already has an evaluation');
    }
    final saved = evaluation.copyWith(localId: evaluation.localId ?? _nextId++);
    _evaluations[saved.localId!] = saved;
    _changed();
    return saved;
  }

  @override
  Stream<List<AiInsight>> watchInsights(int decisionLocalId) =>
      _watch(() => _insightsOf(decisionLocalId));

  @override
  Future<List<AiInsight>> getInsights(
    int decisionLocalId,
    TriggerContext trigger,
  ) async =>
      _insightsOf(decisionLocalId)
          .where((i) => i.triggerContext == trigger)
          .toList();

  @override
  Future<AiInsight> putInsight(AiInsight insight) async {
    final saved = insight.copyWith(localId: insight.localId ?? _nextId++);
    _insights[saved.localId!] = saved;
    _changed();
    return saved;
  }

  @override
  Stream<List<Tag>> watchTags(String userId) => _watch(
        () => _tags.values
            .where((t) =>
                t.userId == userId && t.syncStatus != SyncStatus.pendingDelete)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)),
      );

  @override
  Future<List<Tag>> getTags(String userId) async =>
      _tags.values.where((t) => t.userId == userId).toList();

  @override
  Future<Tag?> getTag(int localId) async => _tags[localId];

  @override
  Future<Tag> putTag(Tag tag) async {
    final clash = _tags.values.any((t) =>
        t.userId == tag.userId && t.name == tag.name && t.localId != tag.localId);
    if (clash) throw StateError('Tag name already used');
    final saved = tag.copyWith(localId: tag.localId ?? _nextId++);
    _tags[saved.localId!] = saved;
    _changed();
    return saved;
  }

  @override
  Future<void> deleteTagPermanently(int localId) async {
    _tags.remove(localId);
    _changed();
  }
}
