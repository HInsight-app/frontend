import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/presentation/controllers/auth_controller.dart';
import 'data/local/decision_local_data_source.dart';
import 'data/remote/decision_remote_data_source.dart';
import 'data/remote/fake_decision_remote_data_source.dart';
import 'data/repositories/decision_repository_impl.dart';
import 'domain/repositories/decision_repository.dart';

/// The on-device store. Opened once in main() (it's async) and supplied with
/// `overrideWithValue`; tests supply their own.
final decisionLocalDataSourceProvider = Provider<DecisionLocalDataSource>(
  (ref) => throw UnimplementedError(
    'decisionLocalDataSourceProvider must be overridden (see main.dart).',
  ),
);

/// The fake server until the backend has the decision endpoints (see
/// DecisionRemoteDataSource for the list). Swap in the Dio version then.
final decisionRemoteDataSourceProvider = Provider<DecisionRemoteDataSource>(
  (ref) => FakeDecisionRemoteDataSource(),
);

/// Used only in the web preview, where login is skipped.
const previewUserId = 'web-preview-user';

final decisionRepositoryProvider = Provider<DecisionRepository>((ref) {
  final user = ref.watch(authControllerProvider).valueOrNull;
  return DecisionRepositoryImpl(
    local: ref.watch(decisionLocalDataSourceProvider),
    remote: ref.watch(decisionRemoteDataSourceProvider),
    userId: user?.id ?? previewUserId,
  );
});
