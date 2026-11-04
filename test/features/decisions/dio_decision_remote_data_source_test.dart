import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/network/api_exception.dart';
import 'package:hinsight/src/features/decisions/data/remote/api_json.dart';
import 'package:hinsight/src/features/decisions/data/remote/decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/dio_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/decisions/domain/entities/evaluation.dart';
import 'package:hinsight/src/features/tags/domain/entities/tag.dart';

/// Answers with [status] and [body] instead of using the network, and keeps
/// the request so tests can check what the app sent.
class _Server implements HttpClientAdapter {
  int status = 200;
  Object? body = const {};
  bool unreachable = false;
  late RequestOptions request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (unreachable) {
      throw DioException.connectionError(
          requestOptions: options, reason: 'No route to host');
    }
    return ResponseBody.fromString(jsonEncode(body), status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _Server server;
  late DioDecisionRemoteDataSource api;

  setUp(() {
    server = _Server();
    api = DioDecisionRemoteDataSource(
        Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = server);
  });

  final created = DateTime.utc(2026, 11, 4, 3, 0);
  final decision = Decision(
    localId: 7,
    serverId: 'd-1',
    userId: 'u1',
    title: 'Pick an elective',
    context: 'Two courses fit',
    confidenceBefore: 60,
    scheduledReviewDate: DateTime(2026, 12, 1),
    createdAt: created,
    updatedAt: created.add(const Duration(minutes: 5)),
    options: [
      DecisionOption(
          key: 'k-1',
          serverId: 'o-1',
          title: 'Data Mining',
          pros: ['Thesis topic', 'Good lecturer'],
          createdAt: created),
      DecisionOption(key: 'k-2', title: 'Game Design', cons: ['Far'], createdAt: created),
    ],
    outcome: DecisionOutcome(
        chosenOptionKey: 'k-2', commitmentNote: 'Fun', decidedAt: created),
  );

  test('POST /decisions sends the decision in the API\'s JSON', () async {
    server
      ..status = 201
      ..body = {
        'id': 'd-1',
        'options': [
          {'id': 'o-1', 'client_key': 'k-1'},
          {'id': 'o-2', 'client_key': 'k-2'},
        ],
      };

    final ids = await api.createDecision(decision, tagServerIds: ['t-1']);

    expect(server.request.method, 'POST');
    expect(server.request.path, '/decisions');
    expect(server.request.headers['Idempotency-Key'],
        'decision-7-${created.microsecondsSinceEpoch}');
    expect(server.request.data, {
      'title': 'Pick an elective',
      'context': 'Two courses fit',
      'confidence_before': 60,
      'scheduled_review_date': '2026-12-01',
      'created_at': '2026-11-04T03:00:00.000Z',
      'updated_at': '2026-11-04T03:05:00.000Z',
      'tag_ids': ['t-1'],
      'options': [
        {
          'id': 'o-1',
          'client_key': 'k-1',
          'title': 'Data Mining',
          'pros': 'Thesis topic\nGood lecturer',
          'cons': null,
          'created_at': '2026-11-04T03:00:00.000Z',
        },
        {
          'id': null,
          'client_key': 'k-2',
          'title': 'Game Design',
          'pros': null,
          'cons': 'Far',
          'created_at': '2026-11-04T03:00:00.000Z',
        },
      ],
      'outcome': {
        'chosen_option_id': null,
        'chosen_option_key': 'k-2',
        'commitment_note': 'Fun',
        'decided_at': '2026-11-04T03:00:00.000Z',
      },
    });
    expect(ids.id, 'd-1');
    expect(ids.optionIds, {'k-1': 'o-1', 'k-2': 'o-2'});
  });

  test('option ids are matched by title when the reply has no client_key',
      () async {
    server.body = {
      'id': 'd-1',
      'options': [
        {'id': 'o-9', 'title': 'game design'},
      ],
    };

    final ids = await api.updateDecision(decision, tagServerIds: const []);

    expect(server.request.method, 'PUT');
    expect(server.request.path, '/decisions/d-1');
    expect(ids.optionIds, {'k-2': 'o-9'});
  });

  test('409 on an edit carries the server\'s newer copy', () async {
    server
      ..status = 409
      ..body = {
        'error': 'A newer version exists',
        'decision': {
          'id': 'd-1',
          'title': 'From the laptop',
          'context': null,
          'confidence_before': 70,
          // How Go encodes a DATE column
          'scheduled_review_date': '2026-12-01T00:00:00Z',
          'created_at': '2026-11-04T03:00:00Z',
          'updated_at': '2026-11-04T04:00:00.123456Z',
          'deleted_at': null,
          'options': [
            {
              'id': 'o-1',
              'title': 'Data Mining',
              'pros': 'Thesis topic\n\nGood lecturer',
              'cons': null,
              'created_at': '2026-11-04T03:00:00Z',
            },
          ],
          'outcome': {
            'chosen_option_id': 'o-1',
            'commitment_note': null,
            'decided_at': '2026-11-04T03:30:00Z',
          },
          'tag_ids': ['t-1'],
        },
      };

    final conflict = await api
        .updateDecision(decision, tagServerIds: const [])
        .then<DecisionConflictException?>((_) => null,
            onError: (Object e) => e as DecisionConflictException);

    final copy = conflict!.serverCopy;
    expect(copy.title, 'From the laptop');
    expect(copy.confidenceBefore, 70);
    expect(copy.scheduledReviewDate, DateTime(2026, 12, 1));
    // Parsed to local time, at the same moment, down to the microsecond.
    expect(copy.updatedAt.isUtc, isFalse);
    expect(copy.updatedAt.toUtc(), DateTime.utc(2026, 11, 4, 4, 0, 0, 123, 456));
    expect(copy.deletedAt, isNull);
    expect(copy.options.single.pros, ['Thesis topic', 'Good lecturer']);
    expect(copy.outcome!.chosenOptionId, 'o-1');
    expect(copy.tagIds, ['t-1']);
  });

  test('404 and offline become ApiExceptions the sync understands', () async {
    server
      ..status = 404
      ..body = {'error': 'decision not found'};
    await expectLater(
      api.updateDecision(decision, tagServerIds: const []),
      throwsA(isA<ApiException>()
          .having((e) => e.statusCode, 'statusCode', 404)
          .having((e) => e.message, 'message', 'decision not found')),
    );

    server.unreachable = true;
    await expectLater(
      api.deleteTag('t-1'),
      throwsA(isA<ApiException>()
          .having((e) => e.isConnectionProblem, 'isConnectionProblem', isTrue)),
    );
  });

  test('DELETE sends the local updated_at for the last-write-wins check',
      () async {
    await api.deleteDecision('d-1', updatedAt: created);

    expect(server.request.method, 'DELETE');
    expect(server.request.path, '/decisions/d-1');
    expect(server.request.queryParameters,
        {'updated_at': '2026-11-04T03:00:00.000Z'});
  });

  test('409 on an evaluation or tag returns the one the server already has',
      () async {
    server
      ..status = 409
      ..body = {'error': 'already evaluated', 'id': 'e-1'};
    final evaluationId = await api.createEvaluation(
      'd-1',
      Evaluation(
          decisionLocalId: 7,
          satisfactionAfter: 80,
          confidenceAfter: 70,
          hindsightNotes: 'Good',
          createdAt: created),
    );
    expect(server.request.path, '/decisions/d-1/evaluations');
    expect(server.request.data, {
      'satisfaction_after': 80,
      'confidence_after': 70,
      'hindsight_notes': 'Good',
      'created_at': '2026-11-04T03:00:00.000Z',
    });
    expect(evaluationId, 'e-1');

    server.body = {'error': 'tag exists', 'id': 't-1'};
    final tagId =
        await api.createTag(const Tag(userId: 'u1', name: 'Academic', colorHex: '#8771FF'));
    expect(server.request.data, {'name': 'Academic', 'color_hex': '#8771FF'});
    expect(tagId, 't-1');
  });

  test('an insight reply is read, with snake_case enums and "none"', () async {
    server
      ..status = 201
      ..body = {
        'id': 'i-1',
        'model_version': 'gemini-2.5-flash',
        'trigger_context': 'post_evaluation',
        'insight_text': 'You felt very sure.',
        'primary_bias': 'loss_aversion',
        'emotional_tone': 'hopeful', // Not one the app knows: ignored
        'risk_level': 'high',
        'actionability_score': 7,
        'suggested_alternative': 'Write down what could change your mind.',
        'model_confidence': 0.82,
        'generated_at': '2026-11-04T05:00:00Z',
      };

    final insight = await api.requestInsight('d-1', TriggerContext.postEvaluation);

    expect(server.request.path, '/decisions/d-1/insights');
    expect(server.request.data, {'trigger_context': 'post_evaluation'});
    expect(insight.primaryBias, BiasType.lossAversion);
    expect(insight.emotionalTone, isNull);
    expect(insight.riskLevel, RiskLevel.high);
    expect(insight.actionabilityScore, 7);
    expect(insight.modelConfidence, 0.82);
    expect(insight.generatedAt.toUtc(), DateTime.utc(2026, 11, 4, 5));

    expect(enumFromApi(BiasType.values, 'none'), isNull);
    expect(enumToApi(BiasType.sunkCost), 'sunk_cost');
    expect(enumToApi(TriggerContext.preDecision), 'pre_decision');
  });

  test('a reply the app can\'t read is a clear error, not a crash', () async {
    server.body = {'unexpected': true};

    await expectLater(
      api.requestInsight('d-1', TriggerContext.preDecision),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', contains('could not read'))),
    );
  });
}
