import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/network/auth_interceptor.dart';
import 'package:hinsight/src/features/auth/auth.dart';

import '../../helpers/fake_auth.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('an empty BASE_URL fails with a message saying how to fix it', () {
    dotenv.loadFromString(envString: 'BASE_URL=');

    expect(
      () => container.read(baseUrlProvider),
      throwsA(isA<StateError>().having(
        (e) => e.message,
        'message',
        contains('.env.example'),
      )),
    );
  });

  test('the shared Dio uses BASE_URL and the auth interceptor', () {
    dotenv.loadFromString(envString: 'BASE_URL=http://10.0.2.2:8080');

    final dio = container.read(dioProvider);

    expect(dio.options.baseUrl, 'http://10.0.2.2:8080');
    expect(dio.interceptors.whereType<AuthInterceptor>(), hasLength(1));
  });

  test('a 401 from the backend signs the user out', () async {
    dotenv.loadFromString(envString: 'BASE_URL=http://10.0.2.2:8080');
    FlutterSecureStorage.setMockInitialValues({TokenStorage.tokenKey: 'old'});
    final signedIn = ProviderContainer(overrides: [
      authRepositoryProvider
          .overrideWithValue(FakeAuthRepository(savedUser: testUser)),
    ]);
    addTearDown(signedIn.dispose);
    expect(await signedIn.read(authControllerProvider.future), testUser);

    final dio = signedIn.read(dioProvider)..httpClientAdapter = _Always401();
    await expectLater(dio.get('/decisions'), throwsA(isA<DioException>()));

    expect(signedIn.read(authControllerProvider).value, isNull);
  });
}

class _Always401 implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"error":"invalid or expired session"}',
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
