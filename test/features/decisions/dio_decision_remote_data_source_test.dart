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

import '../../helpers/fake_http_adapter.dart';

/// A DecisionResponse as the backend sends it (times in the server's zone).
Map<String, Object?> serverDecision({
  String id = 'd-1',
  String title = 'Pick an elective',
  String updatedAt = '2026-11-04T10:05:00+07:00',
  String? deletedAt,
  Map<String, Object?>? outcome,
  Map<String, Object?>? evaluation,
}) =>
    {
      'id': id,
      'user_id': 'u-1',
      'title': title,
      'status': 'pending',
      'context': 'Two courses fit',
      'confidence_before': 70,
      'scheduled_review_date': '2026-12-01',
      'created_at': '2026-11-04T10:00:00+07:00',
      'updated_at': updatedAt,
      'server_updated_at': '2026-11-04T11:00:00.123456+07:00',
      if (deletedAt != null) 'deleted_at': deletedAt,
      'options': [
        {
          'id': 'o-1',
          'decision_id': id,
          'title': 'Data Mining',
          'pros': 'Thesis topic\n\nGood lecturer',
          'created_at': '2026-11-04T10:00:00+07:00',
        },
        {
          'id': 'o-2',
          'decision_id': id,
          'title': 'game design', // Matched to the app's option ignoring case
          'cons': 'Far',
          'created_at': '2026-11-04T10:00:00+07:00',
        },
      ],
      if (outcome != null) 'outcome': outcome,
      if (evaluation != null) 'evaluation': evaluation,
      'tags': [
        {'id': 't-1', 'user_id': 'u-1', 'name': 'Career', 'color_hex': '#8771FF'},
      ],
    };

void main() {
  late FakeHttpAdapter server;
  late DioDecisionRemoteDataSource api;

  setUp(() {
    server = FakeHttpAdapter();
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
  );
  final committed = decision.copyWith(
    outcome: DecisionOutcome(
        chosenOptionKey: 'k-2', commitmentNote: 'Fun', decidedAt: created),
  );

  test('POST /decisions sends the fields the backend reads', () async {
    server
      ..status = 201
      ..body = serverDecision();

    final ids = await api.createDecision(
        decision.copyWith(serverId: null), tagServerIds: ['t-1']);

    expect(server.requests, hasLength(1));
    expect(server.lastRequest.method, 'POST');
    expect(server.lastRequest.path, '/decisions');
    expect(server.lastRequest.headers['Idempotency-Key'],
        'decision-7-${created.microsecondsSinceEpoch}');
    expect(server.lastRequest.data, {
      'title': 'Pick an elective',
      'context': 'Two courses fit',
      'confidence_before': 60,
      'scheduled_review_date': '2026-12-01',
      'created_at': '2026-11-04T03:00:00.000Z',
      'tag_ids': ['t-1'],
      'options': [
        {'title': 'Data Mining', 'pros': 'Thesis topic\nGood lecturer', 'cons': null},
        {'title': 'Game Design', 'pros': null, 'cons': 'Far'},
      ],
    });
    expect(ids.id, 'd-1');
    expect(ids.optionIds, {'k-1': 'o-1', 'k-2': 'o-2'});
  });

  test('a decision committed before its first sync is sent again with its outcome',
      () async {
    server.reply = (request) => (request.path == '/decisions' ? 201 : 200,
        serverDecision(outcome: {
          'decision_id': 'd-1',
          'chosen_option_id': 'o-2',
          'decided_at': '2026-11-04T10:00:00+07:00',
        }));

    final ids = await api.createDecision(
        committed.copyWith(serverId: null), tagServerIds: const []);

    expect([for (final r in server.requests) r.path],
        ['/decisions', '/decisions/d-1/sync']);
    final sync = server.lastRequest.data as Map;
    expect(sync['local_updated_at'], '2026-11-04T03:05:00.000Z');
    expect(sync['options'], [
      {
        'id': 'o-1',
        'client_key': 'k-1',
        'title': 'Data Mining',
        'pros': 'Thesis topic\nGood lecturer',
        'cons': null,
      },
      {'id': 'o-2', 'client_key': 'k-2', 'title': 'Game Design', 'pros': null, 'cons': 'Far'},
    ]);
    expect(sync['outcome'], {
      'chosen_option_id': 'o-2',
      'chosen_option_key': 'k-2',
      'commitment_note': 'Fun',
      'decided_at': '2026-11-04T03:00:00.000Z',
    });
    expect(ids.optionIds, {'k-1': 'o-1', 'k-2': 'o-2'});
  });

  test('POST /decisions/{id}/sync sends the whole decision with local_updated_at',
      () async {
    server.body = serverDecision();

    final ids = await api.updateDecision(committed, tagServerIds: ['t-1']);

    expect(server.lastRequest.method, 'POST');
    expect(server.lastRequest.path, '/decisions/d-1/sync');
    expect(server.lastRequest.data, {
      'title': 'Pick an elective',
      'context': 'Two courses fit',
      'confidence_before': 60,
      'scheduled_review_date': '2026-12-01',
      'created_at': '2026-11-04T03:00:00.000Z',
      'local_updated_at': '2026-11-04T03:05:00.000Z',
      'tag_ids': ['t-1'],
      'options': [
        {
          'id': 'o-1',
          'client_key': 'k-1',
          'title': 'Data Mining',
          'pros': 'Thesis topic\nGood lecturer',
          'cons': null,
        },
        {'id': null, 'client_key': 'k-2', 'title': 'Game Design', 'pros': null, 'cons': 'Far'},
      ],
      'outcome': {
        // The key works even before the chosen option has a server id.
        'chosen_option_id': null,
        'chosen_option_key': 'k-2',
        'commitment_note': 'Fun',
        'decided_at': '2026-11-04T03:00:00.000Z',
      },
    });
    // The reply has no client_key: options are matched by title.
    expect(ids.optionIds, {'k-1': 'o-1', 'k-2': 'o-2'});
  });

  test("409 on an edit carries the server's newer copy, tags and evaluation included",
      () async {
    server
      ..status = 409
      ..body = {
        'error': 'Conflict: server has newer version',
        'decision': serverDecision(
          title: 'From the laptop',
          updatedAt: '2026-11-04T11:00:00.123456+07:00',
          outcome: {
            'decision_id': 'd-1',
            'chosen_option_id': 'o-1',
            'decided_at': '2026-11-04T10:30:00+07:00',
          },
          evaluation: {
            'id': 'e-1',
            'decision_id': 'd-1',
            'satisfaction_after': 80,
            'confidence_after': 65,
            'hindsight_notes': 'Worth it',
            'created_at': '2026-11-05T09:00:00+07:00',
          },
        ),
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
    expect(copy.serverUpdatedAt.toUtc(), DateTime.utc(2026, 11, 4, 4, 0, 0, 123, 456));
    expect(copy.deletedAt, isNull);
    expect(copy.options.first.pros, ['Thesis topic', 'Good lecturer']);
    expect(copy.outcome!.chosenOptionId, 'o-1');
    expect(copy.evaluation!.id, 'e-1');
    expect(copy.evaluation!.hindsightNotes, 'Worth it');
    expect(copy.tags.single.id, 't-1');
    expect(copy.tags.single.name, 'Career');
  });

  test('404 and offline become ApiExceptions the sync understands', () async {
    server
      ..status = 404
      ..body = {'error': 'Decision not found'};
    await expectLater(
      api.updateDecision(decision, tagServerIds: const []),
      throwsA(isA<ApiException>()
          .having((e) => e.statusCode, 'statusCode', 404)
          .having((e) => e.message, 'message', 'Decision not found')),
    );

    server.failure = DioExceptionType.connectionError;
    await expectLater(
      api.deleteTag('t-1'),
      throwsA(isA<ApiException>()
          .having((e) => e.isConnectionProblem, 'isConnectionProblem', isTrue)),
    );
  });

  test('deletes are POSTs, a decision with its local updated_at', () async {
    await api.deleteDecision('d-1', updatedAt: created);
    expect(server.lastRequest.method, 'POST');
    expect(server.lastRequest.path, '/decisions/d-1/delete');
    expect(server.lastRequest.data, {'local_updated_at': '2026-11-04T03:00:00.000Z'});

    await api.deleteTag('t-1');
    expect(server.lastRequest.method, 'POST');
    expect(server.lastRequest.path, '/tags/t-1/delete');
  });

  test('an evaluation is sent with the scores and notes', () async {
    server
      ..status = 201
      ..body = {'id': 'e-1', 'decision_id': 'd-1'};
    final evaluationId = await api.createEvaluation(
      'd-1',
      Evaluation(
          decisionLocalId: 7,
          satisfactionAfter: 80,
          confidenceAfter: 70,
          hindsightNotes: 'Good',
          createdAt: created),
    );
    expect(server.lastRequest.path, '/decisions/d-1/evaluations');
    expect(server.lastRequest.data, {
      'satisfaction_after': 80,
      'confidence_after': 70,
      'hindsight_notes': 'Good',
      'created_at': '2026-11-04T03:00:00.000Z',
    });
    expect(evaluationId, 'e-1');
  });

  test('a tag without a colour gets the default one', () async {
    server
      ..status = 201
      ..body = {'id': 't-1', 'name': 'Academic', 'color_hex': defaultTagColorHex};

    final id = await api.createTag(const Tag(userId: 'u1', name: 'Academic'));

    expect(server.lastRequest.path, '/tags');
    expect(server.lastRequest.data, {'name': 'Academic', 'color_hex': '#8771FF'});
    expect(id, 't-1');
  });

  test('a refused duplicate tag name reuses the tag the server already has',
      () async {
    server.reply = (request) => request.method == 'GET'
        ? (200, [
            {'id': 't-other', 'name': 'Career', 'color_hex': '#000000'},
            {'id': 't-9', 'name': 'academic', 'color_hex': '#8771FF'},
          ])
        : (500, {'error': 'Failed to create tag'});

    final id = await api.createTag(
        const Tag(userId: 'u1', name: 'Academic', colorHex: '#123456'));

    expect([for (final r in server.requests) '${r.method} ${r.path}'],
        ['POST /tags', 'GET /tags']);
    expect(id, 't-9');

    // No tag of that name there: the original error stands.
    server.reply = (request) => request.method == 'GET'
        ? (200, const <Object>[])
        : (500, {'error': 'Failed to create tag'});
    await expectLater(
      api.createTag(const Tag(userId: 'u1', name: 'Sport')),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
    );
  });

  test('a pull asks for changes since the cursor, from the start the first time',
      () async {
    server.body = [
      serverDecision(),
      serverDecision(id: 'd-2', deletedAt: '2026-11-04T12:00:00+07:00'),
    ];

    final pulled = await api.pullDecisions(since: created);

    expect(server.lastRequest.method, 'GET');
    expect(server.lastRequest.path, '/decisions');
    expect(server.lastRequest.queryParameters,
        {'updated_since': '2026-11-04T03:00:00.000Z'});
    expect([for (final d in pulled) d.id], ['d-1', 'd-2']);
    expect(pulled.last.deletedAt!.toUtc(), DateTime.utc(2026, 11, 4, 5));

    // Without updated_since the server would leave deleted decisions out.
    await api.pullDecisions();
    expect(server.lastRequest.queryParameters,
        {'updated_since': '1970-01-01T00:00:00.000Z'});
  });

  test('an insight reply is read, with snake_case enums and "none"', () async {
    server
      ..status = 201
      ..body = {
        'id': 'i-1',
        'decision_id': 'd-1',
        'model_version': 'gemini-2.5-flash',
        'trigger_context': 'post_evaluation',
        'insight_text': 'You felt very sure.',
        'primary_bias': 'loss_aversion',
        'emotional_tone': 'hopeful', // Not one the app knows: ignored
        'risk_level': 'high',
        'actionability_score': 7,
        'suggested_alternative': 'Write down what could change your mind.',
        'model_confidence': 0.82,
        'generated_at': '2026-11-04T12:00:00+07:00',
      };

    final insight = await api.requestInsight('d-1', TriggerContext.postEvaluation);

    expect(server.lastRequest.path, '/decisions/d-1/insights');
    expect(server.lastRequest.data, {'trigger_context': 'post_evaluation'});
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

  test('insight errors from the server read as plain explanations', () async {
    for (final (status, error, expected) in [
      (503, 'AI insights are not configured on this server', 'switched on'),
      (429, 'daily AI insight limit reached', "today's limit"),
      (502, 'the AI model could not generate an insight', 'try again'),
      (400, 'a post_evaluation insight needs an evaluation first', 'evaluation'),
    ]) {
      server
        ..status = status
        ..body = {'error': error};
      await expectLater(
        api.requestInsight('d-1', TriggerContext.postEvaluation),
        throwsA(isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', status)
            .having((e) => e.message, 'message', contains(expected))),
        reason: '$status',
      );
    }
  });

  test("a reply the app can't read is a clear error, not a crash", () async {
    server.body = {'unexpected': true};

    await expectLater(
      api.requestInsight('d-1', TriggerContext.preDecision),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', contains('could not read'))),
    );
  });
}
