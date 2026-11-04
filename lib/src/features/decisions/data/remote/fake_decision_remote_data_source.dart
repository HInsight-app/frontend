import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/uuid.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'decision_remote_data_source.dart';

/// Stands in for the backend until its decision endpoints exist. It keeps
/// "server" copies in memory and answers insight requests with a sample made
/// from simple rules, clearly labelled as such. It is not the AI.
class FakeDecisionRemoteDataSource implements DecisionRemoteDataSource {
  FakeDecisionRemoteDataSource({
    this.latency = const Duration(milliseconds: 800),
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final Duration latency;
  final DateTime Function() _now;

  final _decisions = <String, Decision>{};
  final _evaluations = <String, Evaluation>{};

  /// Set to make every call fail, e.g. to test going offline.
  ApiException? failWith;

  Future<void> _call() async {
    await Future<void>.delayed(latency);
    if (failWith != null) throw failWith!;
  }

  RemoteDecisionIds _store(Decision decision, String id) {
    final optionIds = {
      for (final option in decision.options)
        option.key: option.serverId ?? newUuidV4(),
    };
    _decisions[id] = decision.copyWith(serverId: id);
    return RemoteDecisionIds(id: id, optionIds: optionIds);
  }

  @override
  Future<RemoteDecisionIds> createDecision(Decision decision) async {
    await _call();
    return _store(decision, newUuidV4());
  }

  @override
  Future<RemoteDecisionIds> updateDecision(Decision decision) async {
    await _call();
    final id = decision.serverId;
    if (id == null || !_decisions.containsKey(id)) {
      throw const ApiException('Decision not found', statusCode: 404);
    }
    return _store(decision, id);
  }

  @override
  Future<void> deleteDecision(String serverId) async {
    await _call();
    _decisions.remove(serverId);
  }

  @override
  Future<String> createEvaluation(
    String decisionServerId,
    Evaluation evaluation,
  ) async {
    await _call();
    final id = newUuidV4();
    _evaluations[decisionServerId] = evaluation.copyWith(serverId: id);
    return id;
  }

  @override
  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  ) async {
    await _call();
    final decision = _decisions[decisionServerId];
    if (decision == null) {
      throw const ApiException('Decision not found', statusCode: 404);
    }
    return sampleInsight(
      decision,
      trigger,
      _evaluations[decisionServerId],
      id: newUuidV4(),
      now: _now(),
    );
  }
}

/// Builds a placeholder insight from keyword rules, so the screens can be
/// built and tried before the backend calls Gemini. Its text says so, and its
/// low model confidence makes the app show the AI-limitations warning.
RemoteInsight sampleInsight(
  Decision decision,
  TriggerContext trigger,
  Evaluation? evaluation, {
  required String id,
  required DateTime now,
}) {
  const label = 'Sample analysis: the AI service is not connected yet, so this '
      'was produced by simple rules, not by the AI. ';

  BiasType? bias;
  String finding;
  String? prompt;

  if (trigger == TriggerContext.postEvaluation) {
    final before = decision.confidenceBefore;
    final after = evaluation?.confidenceAfter;
    if (before != null && after != null && before - after >= 20) {
      bias = BiasType.overconfidence;
      finding = 'You felt $before% sure before deciding and $after% sure '
          'afterwards. Looking back, were you more certain than the facts '
          'supported at the time?';
      prompt = 'Next time, note what would change your mind before you commit.';
    } else {
      finding = 'Your confidence before and after deciding is similar. '
          'What helped you judge this decision well?';
    }
  } else {
    final text = [
      decision.title,
      decision.context ?? '',
      for (final o in decision.options) ...[o.title, ...o.pros, ...o.cons],
    ].join(' ').toLowerCase();
    bool mentions(List<String> words) => words.any(text.contains);

    if (mentions(['already spent', 'already paid', 'invested', 'so far',
        'wasted', 'sudah keluar', 'terlanjur'])) {
      bias = BiasType.sunkCost;
      finding = 'You mention what you have already put in. Is that cost '
          'something you can still get back, or only something you can lose '
          'more of?';
      prompt = 'Compare the options only on what happens from today onward.';
    } else if ((decision.confidenceBefore ?? 0) >= 85) {
      bias = BiasType.overconfidence;
      finding = 'You are ${decision.confidenceBefore}% sure already. What '
          'would have to be true for your preferred option to go badly?';
      prompt = 'Write down one way your favourite option could fail.';
    } else if (mentions(['lose', 'losing', 'miss out', 'rugi', 'kehilangan'])) {
      bias = BiasType.lossAversion;
      finding = 'Your notes focus on what you might lose. Are you giving the '
          'possible gains the same weight?';
      prompt = 'List what each option could gain you, not only what it risks.';
    } else if (_onlyOneSideArgued(decision.options)) {
      bias = BiasType.confirmation;
      finding = 'One option has only pros and the others have few. Did you '
          'look for reasons against the option you prefer?';
      prompt = 'Add at least one con to the option you lean towards.';
    } else {
      finding = 'No clear sign of the biases this check looks for. Your '
          'options have reasons on both sides.';
    }
  }

  return RemoteInsight(
    serverId: id,
    modelVersion: 'sample-rules-v1',
    insightText: label + finding,
    generatedAt: now,
    primaryBias: bias,
    emotionalTone: (decision.confidenceBefore ?? 50) < 40
        ? EmotionalTone.uncertain
        : EmotionalTone.neutral,
    riskLevel: bias == null ? RiskLevel.low : RiskLevel.medium,
    actionabilityScore: bias == null ? 3 : 6,
    suggestedAlternative: prompt,
    modelConfidence: 0.3,
  );
}

bool _onlyOneSideArgued(List<DecisionOption> options) {
  if (options.length < 2) return false;
  final favoured = options.where((o) => o.pros.length >= 2 && o.cons.isEmpty);
  final others = options.where((o) => o.pros.isEmpty);
  return favoured.length == 1 && others.length == options.length - 1;
}
