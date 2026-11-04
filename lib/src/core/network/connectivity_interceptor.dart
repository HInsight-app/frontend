import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Watches every API call to tell whether the server can be reached, as the
/// paper describes (III-F): when a call succeeds again after the app was
/// offline, the sync starts. No connectivity package is needed, and "online"
/// means the server itself answered, not only that there is Wi-Fi.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required this.onOnline, required this.onOffline});

  final void Function() onOnline;
  final void Function() onOffline;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    onOnline();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Same rule as ApiException, so the two never disagree.
    if (ApiException.fromDioException(err).isConnectionProblem) {
      onOffline();
    } else if (err.response != null) {
      onOnline(); // An error status still means the server answered
    }
    handler.next(err);
  }
}
