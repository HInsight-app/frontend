import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/network/connection_status.dart';
import 'package:hinsight/src/core/network/connectivity_interceptor.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter server;
  late List<String> reports;
  late Dio dio;

  setUp(() {
    server = FakeHttpAdapter();
    reports = [];
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = server
      ..interceptors.add(ConnectivityInterceptor(
        onOnline: () => reports.add('online'),
        onOffline: () => reports.add('offline'),
      ));
  });

  Future<void> call() async {
    try {
      await dio.get<Object?>('/health');
    } on DioException catch (_) {
      // Only the reports matter here.
    }
  }

  test('any answer from the server means online, even an error status',
      () async {
    await call();
    server.status = 500;
    await call();

    expect(reports, ['online', 'online']);
  });

  test('no connection, or no answer in time, means offline', () async {
    for (final type in [
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      server.failure = type;
      await call();
    }

    expect(reports, ['offline', 'offline', 'offline']);
  });

  test('a cancelled request says nothing about the connection', () async {
    server.failure = DioExceptionType.cancel;
    await call();

    expect(reports, isEmpty);
  });

  test('the shared Dio reports to connectionStatusProvider', () async {
    dotenv.loadFromString(envString: 'BASE_URL=https://api.test');
    // The auth interceptor reads the token from secure storage.
    FlutterSecureStorage.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final shared = container.read(dioProvider)..httpClientAdapter = server;
    expect(container.read(connectionStatusProvider), ConnectionStatus.unknown);

    server.failure = DioExceptionType.connectionError;
    await expectLater(shared.get<Object?>('/health'), throwsA(isA<DioException>()));
    expect(container.read(connectionStatusProvider), ConnectionStatus.offline);

    server.failure = null;
    await shared.get<Object?>('/health');
    expect(container.read(connectionStatusProvider), ConnectionStatus.online);
  });
}
