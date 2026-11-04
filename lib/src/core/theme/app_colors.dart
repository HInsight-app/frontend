import 'package:flutter/material.dart';

/// Every colour from the HInsight style guide. Widgets should normally read
/// colours from `Theme.of(context).colorScheme` (see [AppTheme]), and only use
/// these directly when the scheme has no matching slot, like the status colours.
class AppColors {
  AppColors._();

  // --- Main colours ---
  static const background = Color(0xFF050314); // Page background
  static const foreground = Color(0xFFFAFAFA); // Main text and icons
  static const card = Color(0xFF0C0921); // Cards and sheets
  static const neutral = Color(0xFF141313);
  static const primary = Color(0xFF8771FF); // Brand colour, links, active states
  static const accent = Color(0xFF6C50E9);
  static const secondary = Color(0xFF181535); // Secondary buttons and chips
  static const cta = Color(0xFFCCB7FE); // Filled buttons; use dark text on it

  // --- UI element colours ---
  static const border = Color(0xFF1F1946);
  static const input = Color(0xFF181535); // Text field and muted backgrounds
  static const mutedForeground = Color(0xFF8A88BE); // Sub-text, hints
  static const ring = Color(0xFF8771FF); // Focus outline

  // --- Status colours ---
  // All four are bright, so put dark text ([background]) on them, not white.
  static const success = Color(0xFF05DF72);
  static const warning = Color(0xFFFDC700);
  static const error = Color(0xFFFF6467);
  static const info = Color(0xFF51A2F4);
}
