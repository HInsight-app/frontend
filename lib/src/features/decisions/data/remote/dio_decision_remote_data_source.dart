import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'api_json.dart';
import 'decision_remote_data_source.dart';

/// Calls the backend's decision endpoints through the shared Dio (which adds
/// the login token and watches the connection). The backend doesn't have
/// these endpoints yet; docs/SYNC_API.md lists exactly what this sends and
/// expects, so the backend team can build them to match. Set
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
          data: decisionToJson(decision, tagServerIds),
          // A retry after a lost reply must not create the decision twice.
          options: Options(headers: {
            'Idempotency-Key': 'decision-${decision.localId}-'
                '${decision.createdAt.microsecondsSinceEpoch}',
          }),
        ));
    return _parse(() => idsFromJson(_map(body), decision));
  }

  @override
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    final body = await _send(() => dio.put<Object?>(
          '/decisions/${decision.serverId}',
          data: decisionToJson(decision, tagServerIds),
        ));
    return _parse(() => idsFromJson(_map(body), decision));
  }

  @override
  Future<void> deleteDecision(String serverId, {required DateTime updatedAt}) =>
      _send(() => dio.delete<Object?>(
            '/decisions/$serverId',
            queryParameters: {'updated_at': timestampToApi(updatedAt)},
          ));

  @override
  Future<String> createEvaluation(
    String decisionServerId,
    Evaluation evaluation,
  ) async {
    final body = await _send(
      () => dio.post<Object?>(
        '/decisions/$decisionServerId/evaluations',
        data: {
          'satisfaction_after': evaluation.satisfactionAfter,
          'confidence_after': evaluation.confidenceAfter,
          'hindsight_notes': evaluation.hindsightNotes,
          'created_at': timestampToApi(evaluation.createdAt),
        },
      ),
      // The decision already has one (a retried request): that's the one.
      existingOn409: true,
    );
    return _parse(() => _map(body)['id'] as String);
  }

  @override
  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  ) async {
    final body = await _send(() => dio.post<Object?>(
          '/decisions/$decisionServerId/insights',
          data: {'trigger_context': enumToApi(trigger)},
        ));
    return _parse(() => insightFromJson(_map(body)));
  }

  @override
  Future<String> createTag(Tag tag) async {
    final body = await _send(
      () => dio.post<Object?>(
        '/tags',
        data: {'name': tag.name, 'color_hex': tag.colorHex},
      ),
      // The user already has a tag with this name on the server.
      existingOn409: true,
    );
    return _parse(() => _map(body)['id'] as String);
  }

  @override
  Future<void> deleteTag(String serverId) =>
      _send(() => dio.delete<Object?>('/tags/$serverId'));

  // --- Requests and errors ---

  /// Runs [request] and returns the response body. A 409 for a decision
  /// carries the server's newer copy and becomes a DecisionConflictException;
  /// with [existingOn409] its body is returned instead, as the record the
  /// server already had.
  Future<Object?> _send(
    Future<Response<Object?>> Function() request, {
    bool existingOn409 = false,
  }) async {
    try {
      return (await request()).data;
    } on DioException catch (e) {
      final response = e.response;
      if (response?.statusCode == 409) {
        if (existingOn409) return response!.data;
        final copy = response!.data is Map
            ? _parse(() => conflictFromJson(_map(response.data)))
            : null;
        if (copy != null) throw DecisionConflictException(copy);
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

// --- JSON, in the shape docs/SYNC_API.md describes ---

Map<String, Object?> decisionToJson(Decision d, List<String> tagServerIds) => {
      'title': d.title,
      'context': d.context,
      'confidence_before': d.confidenceBefore,
      'scheduled_review_date':
          d.scheduledReviewDate == null ? null : dateToApi(d.scheduledReviewDate!),
      'created_at': timestampToApi(d.createdAt),
      // The server keeps whichever copy has the later updated_at (III-F).
      'updated_at': timestampToApi(d.updatedAt),
      'tag_ids': tagServerIds,
      'options': [
        for (final o in d.options)
          {
            'id': o.serverId, // Null for an option the server doesn't have yet
            'client_key': o.key,
            'title': o.title,
            'pros': linesToApi(o.pros),
            'cons': linesToApi(o.cons),
            'created_at': timestampToApi(o.createdAt),
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

/// The ids in a create or update reply. Options are matched by the
/// client_key the app sent, or by title (unique per decision) if the server
/// leaves client_key out.
RemoteDecisionIds idsFromJson(Map<String, Object?> json, Decision sent) {
  final optionIds = <String, String>{};
  for (final raw in (json['options'] as List?) ?? const []) {
    final option = (raw as Map).cast<String, Object?>();
    final id = option['id'] as String;
    final key = option['client_key'] as String? ??
        sent.options
            .where((o) =>
                o.title.toLowerCase() ==
                (option['title'] as String?)?.toLowerCase())
            .firstOrNull
            ?.key;
    if (key != null) optionIds[key] = id;
  }
  return RemoteDecisionIds(id: json['id'] as String, optionIds: optionIds);
}

/// The server's copy in a 409 reply: `{"error": ..., "decision": {...}}`, or
/// the decision itself.
RemoteDecision conflictFromJson(Map<String, Object?> json) {
  final record = json['decision'] is Map
      ? (json['decision'] as Map).cast<String, Object?>()
      : json;
  final outcome = record['outcome'] is Map
      ? (record['outcome'] as Map).cast<String, Object?>()
      : null;
  return RemoteDecision(
    id: record['id'] as String,
    title: record['title'] as String,
    context: record['context'] as String?,
    confidenceBefore: (record['confidence_before'] as num?)?.toInt(),
    scheduledReviewDate: dateFromApi(record['scheduled_review_date']),
    createdAt: timestampFromApi(record['created_at']),
    updatedAt: timestampFromApi(record['updated_at']),
    deletedAt: optionalTimestampFromApi(record['deleted_at']),
    options: [
      for (final raw in (record['options'] as List?) ?? const [])
        () {
          final o = (raw as Map).cast<String, Object?>();
          return RemoteOption(
            id: o['id'] as String,
            title: o['title'] as String,
            pros: linesFromApi(o['pros']),
            cons: linesFromApi(o['cons']),
            createdAt: timestampFromApi(o['created_at']),
          );
        }(),
    ],
    outcome: outcome == null
        ? null
        : RemoteOutcome(
            chosenOptionId: outcome['chosen_option_id'] as String,
            commitmentNote: outcome['commitment_note'] as String?,
            decidedAt: timestampFromApi(outcome['decided_at']),
          ),
    tagIds: [
      for (final id in (record['tag_ids'] as List?) ?? const []) id as String,
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
