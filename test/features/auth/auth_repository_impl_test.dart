import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/features/auth/auth.dart';
import 'package:hinsight/src/features/auth/data/models/auth_response.dart';

/// Stands in for the backend: returns [response], or throws [error].
class _FakeRemote implements AuthRemoteDataSource {
  AuthResponse response = const AuthResponse(
    user: AuthUserModel(id: 'u1', email: 'owen@binus.ac.id', displayName: 'Owen'),
    token: 'token-1',
  );
  DioException? error;
  bool? lastRemember;

  @override
  Future<AuthResponse> login(String email, String password, bool remember) async {
    lastRemember = remember;
    if (error != null) throw error!;
    return response;
  }

  @override
  Future<AuthResponse> register(
      String displayName, String email, String password, bool remember) async {
    lastRemember = remember;
    if (error != null) throw error!;
    return response;
  }
}

void main() {
  late _FakeRemote remote;

  // A fresh TokenStorage behaves like the app after a restart: its in-memory
  // token is gone and only what was written to the device remains.
  AuthRepositoryImpl repositoryAfterStart() => AuthRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: AuthLocalDataSourceImpl(
          tokenStorage: TokenStorage(const FlutterSecureStorage()),
          secureStorage: const FlutterSecureStorage(),
        ),
      );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    remote = _FakeRemote();
  });

  test('parses the backend response, including display_name', () {
    final parsed = AuthResponse.fromJson({
      'user': {'id': 'u1', 'email': 'a@b.com', 'display_name': 'Owen Siau'},
      'token': 'raw-token',
    });

    expect(parsed.user.toEntity().displayName, 'Owen Siau');
    expect(parsed.token, 'raw-token');
  });

  test('a remembered login survives an app restart', () async {
    final user = await repositoryAfterStart()
        .login(email: 'owen@binus.ac.id', password: 'Secret123', remember: true);

    expect(user.displayName, 'Owen');
    expect(remote.lastRemember, isTrue);
    expect(await repositoryAfterStart().restoreSession(), user);
  });

  test('an unremembered login works now but not after a restart', () async {
    final tokens = TokenStorage(const FlutterSecureStorage());
    final repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: AuthLocalDataSourceImpl(
        tokenStorage: tokens,
        secureStorage: const FlutterSecureStorage(),
      ),
    );

    await repository.login(email: 'a@b.com', password: 'Secret123', remember: false);

    expect(remote.lastRemember, isFalse);
    expect(await tokens.read(), 'token-1'); // Used by the Dio interceptor now
    expect(await repositoryAfterStart().restoreSession(), isNull);
    // Nothing about the session may be written to the device.
    const device = FlutterSecureStorage();
    expect(await device.read(key: TokenStorage.tokenKey), isNull);
    expect(await device.read(key: 'auth_user'), isNull);
  });

  test('an unremembered login removes an older remembered session', () async {
    await repositoryAfterStart()
        .login(email: 'a@b.com', password: 'Secret123', remember: true);
    await repositoryAfterStart()
        .login(email: 'a@b.com', password: 'Secret123', remember: false);

    expect(await repositoryAfterStart().restoreSession(), isNull);
    expect(await const FlutterSecureStorage().read(key: TokenStorage.tokenKey),
        isNull);
  });

  test('registering signs in and is remembered', () async {
    await repositoryAfterStart()
        .register(displayName: 'Owen', email: 'a@b.com', password: 'Secret123');

    expect(remote.lastRemember, isTrue);
    expect(await repositoryAfterStart().restoreSession(), isNotNull);
  });

  test('a refused login becomes an ApiException with the backend message',
      () async {
    final request = RequestOptions(path: '/auth/login');
    remote.error = DioException(
      requestOptions: request,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: request,
        statusCode: 401,
        data: {'error': 'invalid credentials'},
      ),
    );

    await expectLater(
      repositoryAfterStart().login(email: 'a@b.com', password: 'x', remember: true),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', 'invalid credentials')),
    );
  });

  test('logout forgets the session', () async {
    final repository = repositoryAfterStart();
    await repository.login(email: 'a@b.com', password: 'Secret123', remember: true);

    await repository.logout();

    expect(await repository.restoreSession(), isNull);
    expect(await repositoryAfterStart().restoreSession(), isNull);
  });

  test('unreadable saved user data counts as signed out', () async {
    FlutterSecureStorage.setMockInitialValues({
      TokenStorage.tokenKey: 'token-1',
      'auth_user': 'not json',
    });

    expect(await repositoryAfterStart().restoreSession(), isNull);
  });
}
