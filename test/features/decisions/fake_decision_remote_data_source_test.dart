// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/utils/uuid.dart';
import 'package:hinsight/src/features/decisions/data/remote/fake_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';

void main() {
  final t0 = DateTime(2026, 11, 4);

  Decision decision({
    String title = 'Pick an elective',
    String? context,
    int? confidence,
    List<DecisionOption> options = const [],
  }) =>
      Decision(
        userId: 'u1',
        title: title,
        context: context,
        confidenceBefore: confidence,
        createdAt: t0,
        updatedAt: t0,
        options: options,
      );

  BiasType? biasOf(Decision d) =>
      sampleInsight(d, TriggerContext.preDecision, null, id: 'i', now: t0)
          .primaryBias;

  test('the sample is labelled as not coming from the AI', () {
    final insight = sampleInsight(decision(), TriggerContext.preDecision, null,
        id: 'i', now: t0);

    expect(insight.insightText, startsWith('Sample analysis'));
    expect(insight.insightText, contains('not by the AI'));
    expect(insight.modelVersion, 'sample-rules-v1');
    expect(insight.modelConfidence, lessThan(0.5)); // Shows the limits warning
  });

  test('picks a bias from simple rules, or none', () {
    expect(biasOf(decision(context: "I've already paid the deposit")),
        BiasType.sunkCost);
    expect(biasOf(decision(confidence: 90)), BiasType.overconfidence);
    expect(biasOf(decision(context: 'I am scared to miss out')),
        BiasType.lossAversion);
    expect(
      biasOf(decision(options: [
        DecisionOption(key: 'a', title: 'A', pros: ['x', 'y'], createdAt: t0),
        DecisionOption(key: 'b', title: 'B', createdAt: t0),
      ])),
      BiasType.confirmation,
    );
    expect(biasOf(decision(confidence: 50)), isNull);
  });

  test('newUuidV4 makes distinct version-4 UUIDs', () {
    final pattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
    final ids = List.generate(200, (_) => newUuidV4());

    expect(ids.every(pattern.hasMatch), isTrue);
    expect(ids.toSet(), hasLength(200));
  });
}
