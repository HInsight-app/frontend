import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/network/auth_interceptor.dart';

/// Answers every request with [status] instead of using the network, and
/// remembers the last request so tests can check its headers.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status);

  final int status;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      status == 401 ? '{"error":"invalid or expired session"}' : '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late TokenStorage tokens;
  late int unauthorizedCalls;

  Dio dioAnswering(_FakeAdapter adapter) {
    return Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(AuthInterceptor(
        tokenStorage: tokens,
        onUnauthorized: () => unauthorizedCalls++,
      ));
  }

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({TokenStorage.tokenKey: 'abc123'});
    tokens = TokenStorage(const FlutterSecureStorage());
    unauthorizedCalls = 0;
  });

  test('sends the saved token as a Bearer header', () async {
    final adapter = _FakeAdapter(200);
    await dioAnswering(adapter).get('/decisions');

    expect(adapter.lastRequest!.headers['Authorization'], 'Bearer abc123');
  });

  test('sends no header when there is no token', () async {
    await tokens.delete();
    final adapter = _FakeAdapter(200);
    await dioAnswering(adapter).get('/decisions');

    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);
  });

  test('never sends the token to login or register', () async {
    final adapter = _FakeAdapter(200);
    final dio = dioAnswering(adapter);

    await dio.post('/auth/login');
    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);
    await dio.post('/auth/register');
    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);
  });

  test('a 401 deletes the token, reports it once, and still fails the call',
      () async {
    final dio = dioAnswering(_FakeAdapter(401));

    await expectLater(dio.get('/decisions'), throwsA(isA<DioException>()));
    expect(await tokens.read(), isNull);
    expect(unauthorizedCalls, 1);
  });

  test('a wrong-password 401 from login keeps the session alone', () async {
    final dio = dioAnswering(_FakeAdapter(401));

    await expectLater(dio.post('/auth/login'), throwsA(isA<DioException>()));
    expect(await tokens.read(), 'abc123');
    expect(unauthorizedCalls, 0);
  });

  test('other errors leave the token alone', () async {
    final dio = dioAnswering(_FakeAdapter(500));

    await expectLater(dio.get('/decisions'), throwsA(isA<DioException>()));
    expect(await tokens.read(), 'abc123');
    expect(unauthorizedCalls, 0);
  });
}
