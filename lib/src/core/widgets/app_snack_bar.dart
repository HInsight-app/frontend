import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shows a short message at the bottom of the screen. Pass the messenger
/// rather than a BuildContext, so it is safe to call after an `await`.
void showAppSnackBar(
  ScaffoldMessengerState messenger,
  String message, {
  bool isError = false,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      // Dark text comes from the snackbar theme; it reads well on both colours.
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: isError ? AppColors.error : null,
      duration: const Duration(seconds: 4),
    ));
}
