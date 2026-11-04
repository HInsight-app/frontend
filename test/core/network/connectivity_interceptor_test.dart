import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/network/connection_status.dart';
import 'package:hinsight/src/core/network/connectivity_interceptor.dart';

/// Answers with [status], or fails like a phone with no connection.
class _Server implements HttpClientAdapter {
  int status = 200;
  DioExceptionType? failure;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (failure != null) {
      throw DioException(requestOptions: options, type: failure!);
    }
    return ResponseBody.fromString('{}', status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _Server server;
  late List<String> reports;
  late Dio dio;

  setUp(() {
    server = _Server();
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
