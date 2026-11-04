import 'package:dio/dio.dart';

/// One error type for every failed API call, with a message that is safe to
/// show the user. Repositories catch [DioException] and rethrow this.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.isConnectionProblem = false,
  });

  /// Reads the backend's `{"error": "..."}` body when there is one.
  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          'The server took too long to respond. Please try again.',
          isConnectionProblem: true,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          "Can't reach the server. Check your internet connection.",
          isConnectionProblem: true,
        );
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        return ApiException(
          _backendMessage(e.response?.data) ??
              'Something went wrong (error $status). Please try again.',
          statusCode: status,
        );
      case DioExceptionType.cancel:
        return const ApiException('The request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const ApiException('Something went wrong. Please try again.');
    }
  }

  final String message;

  /// The HTTP status, or null when no response arrived.
  final int? statusCode;

  /// True when the server couldn't be reached at all (offline or timed out),
  /// as opposed to the server answering with an error.
  final bool isConnectionProblem;

  static String? _backendMessage(Object? body) {
    if (body is Map && body['error'] is String) {
      final message = (body['error'] as String).trim();
      if (message.isNotEmpty) return message;
    }
    return null;
  }

  @override
  String toString() => message;
}
