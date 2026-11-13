import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers every Dio request without the network: with [status] and [body]
/// (as JSON), with what [reply] returns for it, or by failing with [failure],
/// like a phone with no connection. Keeps the requests so tests can check
/// what the app sent.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter({this.status = 200, this.body = const {}});

  int status;
  Object? body;
  DioExceptionType? failure;

  /// The status and body for one request, or null for [status] and [body].
  (int, Object?)? Function(RequestOptions request)? reply;

  final requests = <RequestOptions>[];
  RequestOptions get lastRequest => requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (failure != null) {
      throw DioException(requestOptions: options, type: failure!);
    }
    final (replyStatus, replyBody) = reply?.call(options) ?? (status, body);
    return ResponseBody.fromString(jsonEncode(replyBody), replyStatus, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}
