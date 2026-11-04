import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/features/auth/auth.dart';

import '../../helpers/fake_auth.dart';

void main() {
  late FakeAuthRepository repository;
  late ProviderContainer container;

  ProviderContainer containerWith(FakeAuthRepository repo) => ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );

  tearDown(() => container.dispose());

  test('starts signed in when a session was remembered', () async {
    repository = FakeAuthRepository(savedUser: testUser);
    container = containerWith(repository);

    expect(await container.read(authControllerProvider.future), testUser);
  });

  test('starts signed out, then login and logout update the session',
      () async {
    repository = FakeAuthRepository();
    container = containerWith(repository);
    expect(await container.read(authControllerProvider.future), isNull);

    await container.read(authControllerProvider.notifier).login(
          email: 'owen@binus.ac.id',
          password: 'Secret123',
          remember: true,
        );
    expect(container.read(authControllerProvider).value, testUser);

    await container.read(authControllerProvider.notifier).logout();
    expect(container.read(authControllerProvider).value, isNull);
    expect(repository.logoutCalls, 1);
  });

  test('a failed login leaves the user signed out and rethrows', () async {
    repository = FakeAuthRepository()
      ..error = const ApiException('invalid credentials', statusCode: 401);
    container = containerWith(repository);
    await container.read(authControllerProvider.future);

    await expectLater(
      container.read(authControllerProvider.notifier).login(
            email: 'a@b.com',
            password: 'wrong',
            remember: false,
          ),
      throwsA(isA<ApiException>()),
    );
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('an expired session signs the user out', () async {
    repository = FakeAuthRepository(savedUser: testUser);
    container = containerWith(repository);
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).onSessionExpired();

    expect(container.read(authControllerProvider).value, isNull);
  });
}
