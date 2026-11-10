import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers every Dio request without the network: with [status] and [body]
/// (as JSON), or by failing with [failure], like a phone with no connection.
/// Keeps the last request so tests can check what the app sent.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter({this.status = 200, this.body = const {}});

  int status;
  Object? body;
  DioExceptionType? failure;
  late RequestOptions lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (failure != null) {
      throw DioException(requestOptions: options, type: failure!);
    }
    return ResponseBody.fromString(jsonEncode(body), status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}
