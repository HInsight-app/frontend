import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/network/auth_interceptor.dart';

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
}
