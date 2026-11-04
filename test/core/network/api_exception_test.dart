import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';

DioException _error(DioExceptionType type, {int? status, Object? body}) {
  final request = RequestOptions(path: '/decisions');
  return DioException(
    requestOptions: request,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: request, statusCode: status, data: body),
  );
}

void main() {
  test('uses the message from the backend {"error": ...} body', () {
    final e = ApiException.fromDioException(_error(
      DioExceptionType.badResponse,
      status: 401,
      body: {'error': 'invalid or expired session'},
    ));

    expect(e.message, 'invalid or expired session');
    expect(e.statusCode, 401);
    expect(e.isConnectionProblem, isFalse);
  });

  test('falls back to a generic message when the body has no error text', () {
    for (final body in [null, 'Internal Server Error', {'error': ''}, {'message': 'x'}]) {
      final e = ApiException.fromDioException(
        _error(DioExceptionType.badResponse, status: 500, body: body),
      );
      expect(e.message, contains('error 500'), reason: '$body');
    }
  });

  test('marks offline and timeout errors as connection problems', () {
    for (final type in [
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      final e = ApiException.fromDioException(_error(type));
      expect(e.isConnectionProblem, isTrue, reason: '$type');
      expect(e.statusCode, isNull, reason: '$type');
    }
  });
}
