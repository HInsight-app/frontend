import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether signed-out users are sent to the login page. Off only in web debug
/// builds: web is a UI preview (Isar doesn't run there) and the backend sends
/// no CORS headers, so logging in from a browser can't work.
///
/// In its own file so features can read it without importing the router.
final authRedirectEnabledProvider = Provider<bool>(
  (ref) => !(kIsWeb && kDebugMode),
);
