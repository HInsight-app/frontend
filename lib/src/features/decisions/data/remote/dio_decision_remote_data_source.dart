import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'api_json.dart';
import 'decision_remote_data_source.dart';

/// Calls the backend's decision and tag endpoints through the shared Dio
/// (which adds the login token and watches the connection). Set
/// DECISION_API=live in .env to use it.
class DioDecisionRemoteDataSource implements DecisionRemoteDataSource {
  DioDecisionRemoteDataSource(this.dio);

  final Dio dio;

  static const _unreadable =
      ApiException('The server sent a reply the app could not read.');

  @override
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    final body = await _send(() => dio.post<Object?>(
          '/decisions',
          data: createDecisionToJson(decision, tagServerIds),
          // A retry after a lost reply must not create the decision twice.
          options: Options(headers: {
            'Idempotency-Key': 'decision-${decision.localId}-'
                '${decision.createdAt.microsecondsSinceEpoch}',
          }),
        ));
    final ids = _parse(() => idsFromJson(_map(body), decision));
    if (decision.outcome == null) return ids;
    // POST /decisions ignores the outcome, so a decision committed before
    // its first sync is sent again whole.
    return updateDecision(
      decision.copyWith(
        serverId: ids.id,
        options: [
          for (final o in decision.options)
            o.copyWith(serverId: ids.optionIds[o.key] ?? o.serverId),
        ],
      ),
      tagServerIds: tagServerIds,
    );
  }

  @override
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    final body = await _send(() => dio.post<Object?>(
          '/decisions/${decision.serverId}/sync',
          data: syncDecisionToJson(decision, tagServerIds),
        ));
    return _parse(() => idsFromJson(_map(body), decision));
  }

  @override
  Future<void> deleteDecision(String serverId, {required DateTime updatedAt}) =>
      _send(() => dio.post<Object?>(
            '/decisions/$serverId/delete',
            data: {'local_updated_at': timestampToApi(updatedAt)},
          ));

  @override
  Future<String> createEvaluation(
    String decisionServerId,
    Evaluation evaluation,
  ) async {
    // The server keeps one evaluation per decision and answers a retry with
    // the same one.
    final body = await _send(() => dio.post<Object?>(
          '/decisions/$decisionServerId/evaluations',
          data: {
            'satisfaction_after': evaluation.satisfactionAfter,
            'confidence_after': evaluation.confidenceAfter,
            'hindsight_notes': evaluation.hindsightNotes,
            'created_at': timestampToApi(evaluation.createdAt),
          },
        ));
    return _parse(() => _map(body)['id'] as String);
  }

  @override
  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  ) async {
    try {
      final body = await _send(() => dio.post<Object?>(
            '/decisions/$decisionServerId/insights',
            data: {'trigger_context': enumToApi(trigger)},
          ));
      return _parse(() => insightFromJson(_map(body)));
    } on ApiException catch (e) {
      final message = _insightErrors[e.statusCode];
      if (message == null) rethrow;
      throw ApiException(message, statusCode: e.statusCode);
    }
  }

  static const _insightErrors = {
    400: 'The AI needs your evaluation of this decision first. Please try '
        'again once it has synced.',
    429: "You've reached today's limit of AI checks. Please try again "
        'tomorrow.',
    502: "The AI couldn't analyse this decision just now. Please try again "
        'in a moment.',
    503: "AI insights aren't switched on for this server yet.",
  };

  @override
  Future<String> createTag(Tag tag) async {
    try {
      final body = await _send(() => dio.post<Object?>(
            '/tags',
            data: {
              'name': tag.name,
              'color_hex': tag.colorHex ?? defaultTagColorHex,
            },
          ));
      return _parse(() => _map(body)['id'] as String);
    } on ApiException catch (e) {
      // A name the user already has can come back as an error (500) instead
      // of the existing tag: look that tag up.
      if (e.statusCode != 500 && e.statusCode != 409) rethrow;
      return await _existingTagId(tag.name) ?? (throw e);
    }
  }

  /// GET /tags: the id of the user's tag with this name, ignoring case
  /// unless the name is there exactly.
  Future<String?> _existingTagId(String name) async {
    final body = await _send(() => dio.get<Object?>('/tags'));
    return _parse(() {
      final tags = [for (final raw in body as List) _map(raw)];
      final exact = tags.where((t) => t['name'] == name);
      final sameName = exact.isNotEmpty
          ? exact
          : tags.where(
              (t) => (t['name'] as String).toLowerCase() == name.toLowerCase());
      return sameName.firstOrNull?['id'] as String?;
    });
  }

  @override
  Future<void> deleteTag(String serverId) =>
      _send(() => dio.post<Object?>('/tags/$serverId/delete'));

  @override
  Future<List<RemoteDecision>> pullDecisions({DateTime? since}) async {
    final body = await _send(() => dio.get<Object?>(
          '/decisions',
          queryParameters: {
            // Without updated_since the server leaves deleted decisions out.
            'updated_since': timestampToApi(since ?? DateTime.utc(1970)),
          },
        ));
    return _parse(
        () => [for (final raw in body as List) decisionFromJson(_map(raw))]);
  }

  // --- Requests and errors ---

  /// Runs [request] and returns the response body. A 409 that carries the
  /// server's newer copy of a decision becomes a DecisionConflictException.
  Future<Object?> _send(Future<Response<Object?>> Function() request) async {
    try {
      return (await request()).data;
    } on DioException catch (e) {
      final body = e.response?.data;
      if (e.response?.statusCode == 409 && body is Map && body['decision'] is Map) {
        throw DecisionConflictException(
            _parse(() => decisionFromJson(_map(body['decision']))));
      }
      throw ApiException.fromDioException(e);
    }
  }

  static T _parse<T>(T Function() read) {
    try {
      return read();
    } on TypeError {
      throw _unreadable;
    } on FormatException {
      throw _unreadable;
    }
  }

  static Map<String, Object?> _map(Object? json) =>
      (json as Map).cast<String, Object?>();
}

// --- JSON, in the shape the backend's request and response DTOs use ---

Map<String, Object?> _decisionFields(Decision d, List<String> tagServerIds) => {
      'title': d.title,
      'context': d.context,
      'confidence_before': d.confidenceBefore,
      'scheduled_review_date':
          d.scheduledReviewDate == null ? null : dateToApi(d.scheduledReviewDate!),
      'created_at': timestampToApi(d.createdAt),
      'tag_ids': tagServerIds,
    };

/// POST /decisions. The server sets updated_at to created_at and doesn't
/// read the outcome.
Map<String, Object?> createDecisionToJson(Decision d, List<String> tagServerIds) => {
      ..._decisionFields(d, tagServerIds),
      'options': [
        for (final o in d.options)
          {
            'title': o.title,
            'pros': linesToApi(o.pros),
            'cons': linesToApi(o.cons),
          },
      ],
    };

/// POST /decisions/{id}/sync: the whole decision. Options the request leaves
/// out are deleted on the server.
Map<String, Object?> syncDecisionToJson(Decision d, List<String> tagServerIds) => {
      ..._decisionFields(d, tagServerIds),
      // The server keeps whichever copy has the later updated_at (III-F).
      'local_updated_at': timestampToApi(d.updatedAt),
      'options': [
        for (final o in d.options)
          {
            'id': o.serverId, // Null for an option the server doesn't have yet
            'client_key': o.key,
            'title': o.title,
            'pros': linesToApi(o.pros),
            'cons': linesToApi(o.cons),
          },
      ],
      'outcome': d.outcome == null
          ? null
          : {
              // The key works even before the chosen option has a server id.
              'chosen_option_id': d.chosenOption?.serverId,
              'chosen_option_key': d.outcome!.chosenOptionKey,
              'commitment_note': d.outcome!.commitmentNote,
              'decided_at': timestampToApi(d.outcome!.decidedAt),
            },
    };

/// The ids in a create or sync reply. The server doesn't echo client keys,
/// so options are matched by title (unique per decision, ignoring case).
RemoteDecisionIds idsFromJson(Map<String, Object?> json, Decision sent) {
  final optionIds = <String, String>{};
  for (final raw in (json['options'] as List?) ?? const []) {
    final option = (raw as Map).cast<String, Object?>();
    final title = (option['title'] as String).toLowerCase();
    final key =
        sent.options.where((o) => o.title.toLowerCase() == title).firstOrNull?.key;
    if (key != null) optionIds[key] = option['id'] as String;
  }
  return RemoteDecisionIds(id: json['id'] as String, optionIds: optionIds);
}

/// A DecisionResponse: in a pull, or as the server's copy in a 409 reply.
RemoteDecision decisionFromJson(Map<String, Object?> json) {
  Map<String, Object?>? object(String key) =>
      json[key] is Map ? (json[key] as Map).cast<String, Object?>() : null;
  List<Map<String, Object?>> objects(String key) => [
        for (final raw in (json[key] as List?) ?? const [])
          (raw as Map).cast<String, Object?>(),
      ];

  final outcome = object('outcome');
  final evaluation = object('evaluation');
  return RemoteDecision(
    id: json['id'] as String,
    title: json['title'] as String,
    context: json['context'] as String?,
    confidenceBefore: (json['confidence_before'] as num?)?.toInt(),
    scheduledReviewDate: dateFromApi(json['scheduled_review_date']),
    createdAt: timestampFromApi(json['created_at']),
    updatedAt: timestampFromApi(json['updated_at']),
    serverUpdatedAt: timestampFromApi(json['server_updated_at']),
    deletedAt: optionalTimestampFromApi(json['deleted_at']),
    options: [
      for (final o in objects('options'))
        RemoteOption(
          id: o['id'] as String,
          title: o['title'] as String,
          pros: linesFromApi(o['pros']),
          cons: linesFromApi(o['cons']),
          createdAt: timestampFromApi(o['created_at']),
        ),
    ],
    outcome: outcome == null
        ? null
        : RemoteOutcome(
            chosenOptionId: outcome['chosen_option_id'] as String,
            commitmentNote: outcome['commitment_note'] as String?,
            decidedAt: timestampFromApi(outcome['decided_at']),
          ),
    evaluation: evaluation == null
        ? null
        : RemoteEvaluation(
            id: evaluation['id'] as String,
            satisfactionAfter: (evaluation['satisfaction_after'] as num?)?.toInt(),
            confidenceAfter: (evaluation['confidence_after'] as num?)?.toInt(),
            hindsightNotes: evaluation['hindsight_notes'] as String?,
            createdAt: timestampFromApi(evaluation['created_at']),
          ),
    tags: [
      for (final t in objects('tags'))
        RemoteTag(
          id: t['id'] as String,
          name: t['name'] as String,
          colorHex: t['color_hex'] as String?,
        ),
    ],
  );
}

RemoteInsight insightFromJson(Map<String, Object?> json) => RemoteInsight(
      serverId: json['id'] as String,
      modelVersion: json['model_version'] as String,
      insightText: json['insight_text'] as String,
      generatedAt: timestampFromApi(json['generated_at']),
      primaryBias: enumFromApi(BiasType.values, json['primary_bias']),
      emotionalTone: enumFromApi(EmotionalTone.values, json['emotional_tone']),
      riskLevel: enumFromApi(RiskLevel.values, json['risk_level']),
      actionabilityScore: (json['actionability_score'] as num?)?.toInt(),
      suggestedAlternative: json['suggested_alternative'] as String?,
      modelConfidence: (json['model_confidence'] as num?)?.toDouble(),
    );
