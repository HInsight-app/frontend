import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import 'data/local/decision_local_data_source.dart';
import 'data/remote/decision_remote_data_source.dart';
import 'data/remote/dio_decision_remote_data_source.dart';
import 'data/remote/fake_decision_remote_data_source.dart';
import 'data/repositories/decision_repository_impl.dart';
import 'data/repositories/sync_repository_impl.dart';
import 'domain/repositories/decision_repository.dart';

/// The on-device store. Opened once in main() (it's async) and supplied with
/// `overrideWithValue`; tests supply their own.
final decisionLocalDataSourceProvider = Provider<DecisionLocalDataSource>(
  (ref) => throw UnimplementedError(
    'decisionLocalDataSourceProvider must be overridden (see main.dart).',
  ),
);

/// Whether .env asks for the real backend (DECISION_API=live). Anything else,
/// or no value, means the fake server: the backend doesn't have the decision
/// endpoints yet (see docs/SYNC_API.md).
bool useLiveDecisionApi() =>
    dotenv.isInitialized &&
    dotenv.env['DECISION_API']?.trim().toLowerCase() == 'live';

/// The fake server, or the real one through the shared Dio when
/// DECISION_API=live.
final decisionRemoteDataSourceProvider = Provider<DecisionRemoteDataSource>(
  (ref) => useLiveDecisionApi()
      ? DioDecisionRemoteDataSource(ref.watch(dioProvider))
      : FakeDecisionRemoteDataSource(),
);

/// Used only in the web preview, where login is skipped.
const previewUserId = 'web-preview-user';

/// The signed-in student's id, whose records the app shows and syncs.
final currentUserIdProvider = Provider<String>(
  (ref) => ref.watch(authControllerProvider).valueOrNull?.id ?? previewUserId,
);

/// Sends the changes saved on the device to the server (paper III-F).
final syncRepositoryProvider = Provider<SyncRepositoryImpl>(
  (ref) => SyncRepositoryImpl(
    local: ref.watch(decisionLocalDataSourceProvider),
    remote: ref.watch(decisionRemoteDataSourceProvider),
    userId: ref.watch(currentUserIdProvider),
  ),
);

final decisionRepositoryProvider = Provider<DecisionRepository>(
  (ref) => DecisionRepositoryImpl(
    local: ref.watch(decisionLocalDataSourceProvider),
    remote: ref.watch(decisionRemoteDataSourceProvider),
    sync: ref.watch(syncRepositoryProvider),
    userId: ref.watch(currentUserIdProvider),
  ),
);
