import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/auth/domain/entities/auth_user.dart';

import '../../helpers/fake_auth.dart';

void main() {
  const loading = AsyncLoading<AuthUser?>();
  const signedOut = AsyncData<AuthUser?>(null);
  const signedIn = AsyncData<AuthUser?>(testUser);

  test('waits on the splash page while the saved session is checked', () {
    expect(authRedirect(loading, '/'), '/splash');
    expect(authRedirect(loading, '/history'), '/splash');
    expect(authRedirect(loading, '/splash'), isNull);
  });

  test('sends signed-out users to login, except on login and register', () {
    expect(authRedirect(signedOut, '/'), '/login');
    expect(authRedirect(signedOut, '/history'), '/login');
    expect(authRedirect(signedOut, '/splash'), '/login');
    expect(authRedirect(signedOut, '/login'), isNull);
    expect(authRedirect(signedOut, '/register'), isNull);
  });

  test('sends signed-in users from login, register and splash to the dashboard',
      () {
    expect(authRedirect(signedIn, '/login'), '/');
    expect(authRedirect(signedIn, '/register'), '/');
    expect(authRedirect(signedIn, '/splash'), '/');
    expect(authRedirect(signedIn, '/'), isNull);
    expect(authRedirect(signedIn, '/history'), isNull);
  });

  test('a failed session check counts as signed out', () {
    final failed = AsyncError<AuthUser?>(Exception('storage'), StackTrace.empty);
    expect(authRedirect(failed, '/'), '/login');
  });
}
