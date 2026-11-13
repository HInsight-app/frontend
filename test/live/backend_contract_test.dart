// Runs the app's real data layer against a running backend, as two devices
// of one new account. Skipped unless the backend's address is given:
//
//   flutter test test/live --dart-define=LIVE_API_URL=http://localhost:8080
//
// Never point it at the deployed server: it registers a throwaway account.
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/core/network/api_exception.dart';
import 'package:hinsight/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/local/memory_decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/dio_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/repositories/decision_repository_impl.dart';
import 'package:hinsight/src/features/decisions/data/repositories/sync_repository_impl.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';

import '../helpers/fake_decisions.dart';

const liveUrl = String.fromEnvironment('LIVE_API_URL');

/// One device: its own store and pull cursor, the shared account.
class _Device {
  _Device(DioDecisionRemoteDataSource remote, String userId,
      {Duration clockAhead = Duration.zero}) {
    DateTime now() => DateTime.now().add(clockAhead);
    sync = SyncRepositoryImpl(
        local: local,
        remote: remote,
        userId: userId,
        cursors: MemoryPullCursors(),
        clock: now);
    repo = DecisionRepositoryImpl(
        local: local, remote: remote, sync: sync, userId: userId, clock: now);
  }

  final local = MemoryDecisionLocalDataSource();
  late final SyncRepositoryImpl sync;
  late final DecisionRepositoryImpl repo;

  Future<Decision> titled(String title) async =>
      (await repo.watchDecisions().first).singleWhere((d) => d.title == title);
}

void main() {
  late Dio dio;
  late _Device phone;
  late _Device laptop;

  Future<Map<String, Object?>> onServer(String id) async =>
      ((await dio.get<Object?>('/decisions/$id')).data as Map)
          .cast<String, Object?>();

  setUpAll(() async {
    if (liveUrl.isEmpty) return;
    final random = Random.secure();
    String randomHex(int bytes) => [
          for (var i = 0; i < bytes; i++)
            random.nextInt(256).toRadixString(16).padLeft(2, '0'),
        ].join();
    final registered = await Dio(BaseOptions(baseUrl: liveUrl)).post<Map<String, Object?>>(
      '/auth/register',
      data: {
        'email': 'live-test-${randomHex(4)}@example.test',
        'display_name': 'Live Test',
        'password': randomHex(16),
        'remember': true,
      },
    );
    final token = registered.data!['token'] as String;
    final userId = (registered.data!['user'] as Map)['id'] as String;
    dio = Dio(BaseOptions(
      baseUrl: liveUrl,
      contentType: Headers.jsonContentType,
      headers: {'Authorization': 'Bearer $token'},
    ));
    final remote = DioDecisionRemoteDataSource(dio);
    phone = _Device(remote, userId);
    // An hour ahead, so its edits are newer than the phone's.
    laptop = _Device(remote, userId, clockAhead: const Duration(hours: 1));
  });

  group('live backend', skip: liveUrl.isEmpty ? 'Set --dart-define=LIVE_API_URL' : false,
      () {
    test('a decision committed before its first sync reaches the server whole',
        () async {
      final tag = await phone.repo.createTag('Career');
      final d = await phone.repo.createDecision(DecisionDraft(
        title: 'Pick an elective',
        context: 'Two courses fit',
        confidenceBefore: 80,
        options: const [
          OptionDraft(title: 'Data Mining', pros: ['Thesis topic', 'Good lecturer']),
          OptionDraft(title: 'Game Design', cons: ['Far']),
        ],
        tagLocalIds: [tag.localId!],
      ));
      final committed = await phone.repo.commitDecision(d.localId!,
          chosenOptionKey: d.options.last.key, commitmentNote: 'More fun');

      final report = await phone.sync.syncPendingChanges();

      expect(report.failures, isEmpty);
      expect(report.remaining, 0);
      final synced = (await phone.local.getDecision(d.localId!))!;
      final server = await onServer(synced.serverId!);
      expect(server['status'], 'decided');
      expect(server['context'], 'Two courses fit');
      expect(server['confidence_before'], 80);
      expect((server['outcome'] as Map)['chosen_option_id'],
          synced.chosenOption!.serverId);
      expect((server['outcome'] as Map)['commitment_note'], 'More fun');
      expect([for (final t in server['tags'] as List) (t as Map)['name']], ['Career']);
      expect(
          [for (final o in server['options'] as List) (o as Map)['pros']],
          containsAll(['Thesis topic\nGood lecturer']));
      expect(DateTime.parse(server['updated_at'] as String)
          .isAtSameMomentAs(committed.updatedAt), isTrue);
      debugPrint('created and committed ${synced.serverId}: '
          'status ${server['status']}, tags ${server['tags']}');
    });

    test('an evaluation reaches the server; the AI answers or says why not',
        () async {
      final d = await phone.titled('Pick an elective');
      await phone.repo.evaluateDecision(d.localId!,
          satisfactionAfter: 75, confidenceAfter: 60, hindsightNotes: 'Worth it');

      final report = await phone.sync.syncPendingChanges();

      expect(report.failures, isEmpty);
      final server = await onServer(d.serverId!);
      final evaluation = (await phone.local.getEvaluation(d.localId!))!;
      expect(server['status'], 'evaluated');
      expect((server['evaluation'] as Map)['hindsight_notes'], 'Worth it');
      expect((server['evaluation'] as Map)['id'], evaluation.serverId);
      expect(evaluation.syncStatus, SyncStatus.synced);

      try {
        final insight =
            await phone.repo.requestInsight(d.localId!, TriggerContext.postEvaluation);
        expect(insight.status, InsightStatus.complete);
        debugPrint('insight: ${insight.modelVersion}, ${insight.primaryBias}');
      } on ApiException catch (e) {
        // No GEMINI_API_KEY on the server.
        expect(e.statusCode, 503);
        expect(e.message, contains('switched on'));
        debugPrint('insight: ${e.statusCode} "${e.message}"');
      }
    });

    test("a pull brings another device's decision; one tag name is one tag",
        () async {
      final tag = await laptop.repo.createTag('Career');
      await laptop.repo.createDecision(DecisionDraft(
        title: 'Join a club',
        options: const [OptionDraft(title: 'Robotics'), OptionDraft(title: 'Debate')],
        tagLocalIds: [tag.localId!],
      ));
      final laptopReport = await laptop.sync.syncPendingChanges();
      expect(laptopReport.failures, isEmpty);
      final phoneTag = (await phone.repo.watchTags().first).single;
      expect((await laptop.local.getTag(tag.localId!))!.serverId, phoneTag.serverId);

      final report = await phone.sync.syncPendingChanges();

      expect(report.failures, isEmpty);
      final pulled = await phone.titled('Join a club');
      expect(pulled.syncStatus, SyncStatus.synced);
      expect([for (final o in pulled.options) o.title], ['Robotics', 'Debate']);
      expect(pulled.tagLocalIds, [phoneTag.localId]);
      // The laptop pulled the phone's decision too, with its evaluation.
      final fromPhone = await laptop.titled('Pick an elective');
      expect(fromPhone.status, DecisionStatus.evaluated);
      expect((await laptop.local.getEvaluation(fromPhone.localId!))!.hindsightNotes,
          'Worth it');
    });

    test('409: the newer edit from the other device wins', () async {
      final onLaptop = await laptop.titled('Join a club');
      await laptop.repo.updateDecision(onLaptop.localId!,
          _same(onLaptop, title: 'Join the debate club'));
      await laptop.sync.syncPendingChanges();
      final onPhone = await phone.titled('Join a club');
      await phone.repo.updateDecision(
          onPhone.localId!, _same(onPhone, title: 'Join the robotics club'));

      final report = await phone.sync.syncPendingChanges();

      expect(report.serverVersionsKept, ['Join the robotics club']);
      final after = (await phone.local.getDecision(onPhone.localId!))!;
      expect(after.title, 'Join the debate club');
      expect(after.syncStatus, SyncStatus.synced);
      expect((await onServer(after.serverId!))['title'], 'Join the debate club');
    });

    test('a deletion reaches the server and the other device', () async {
      final d = await phone.titled('Pick an elective');
      await phone.repo.deleteDecision(d.localId!);

      final report = await phone.sync.syncPendingChanges();

      expect(report.failures, isEmpty);
      await expectLater(
        dio.get<Object?>('/decisions/${d.serverId}'),
        throwsA(isA<DioException>()
            .having((e) => e.response?.statusCode, 'status', 404)),
      );
      await laptop.sync.syncPendingChanges();
      expect([for (final x in await laptop.repo.watchDecisions().first) x.title],
          ['Join the debate club']);
    });

    test('logout ends the session on the server', () async {
      await AuthRemoteDataSourceImpl(dio: dio).logout();

      await expectLater(
        dio.get<Object?>('/tags'),
        throwsA(isA<DioException>()
            .having((e) => e.response?.statusCode, 'status', 401)),
      );
    });
  });
}

/// The decision's draft as the edit form fills it, with a new [title].
DecisionDraft _same(Decision d, {required String title}) => DecisionDraft(
      title: title,
      context: d.context,
      confidenceBefore: d.confidenceBefore,
      scheduledReviewDate: d.scheduledReviewDate,
      options: [
        for (final o in d.options)
          OptionDraft(key: o.key, title: o.title, pros: o.pros, cons: o.cons),
      ],
      tagLocalIds: d.tagLocalIds,
    );
