import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // The private constructor `AppTheme._()` prevents anyone from accidentally
  // creating an instance of this class (e.g., `var theme = AppTheme()`).
  // We only want to access the static properties directly.
  AppTheme._();

  // --- 1. CORE COLOR PALETTE ---
  // Using 'static const' means these colors are locked into memory once,
  // making the app highly performant.
  static const _backgroundDark = Color(0xFF1E1E1E); // Main background
  static const _surfaceDark =
      Color(0xFF2C2C2C); // Cards, text field backgrounds
  static const _primaryPurple =
      Color(0xFFBB86FC); // Brand color, active states, buttons
  static const _textWhite = Color(0xFFEEEEEE); // Main readable text
  static const _textGrey = Colors.grey; // Secondary text, hints, placeholders

  // --- 2. DARK THEME DEFINITION ---
  static ThemeData get darkTheme {
    // First, we set up the "Base Theme". This tells Flutter the foundational
    // rules for the entire app (like the background color and the primary brand color).
    final baseTheme = ThemeData(
      useMaterial3: true, // Always use Material 3 for modern Flutter apps
      scaffoldBackgroundColor:
          _backgroundDark, // Sets the default background for every screen

      // ColorScheme maps our custom colors to Flutter's internal logic
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryPurple,
        primary: _primaryPurple,
        surface: _surfaceDark,
        brightness: Brightness
            .dark, // Tells widgets like text fields to assume a dark background
      ),
    );

    // Now, we take that base theme and overwrite specific parts of it (copyWith)
    // with our exact UI requirements for typography, inputs, and buttons.
    return baseTheme.copyWith(
      // --- 3. TYPOGRAPHY (8-Point Scale) ---
      // We wrap the default text theme in GoogleFonts to apply Plus Jakarta Sans globally.
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme).copyWith(
        // 32px: Used for massive hero text (e.g., "Welcome Back" on Login)
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w800, // Extra Bold
          color: _textWhite,
        ),

        // 28px: Used for primary page headers
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.w700, // Bold
          color: _textWhite,
        ),

        // 24px: Used for secondary headers or pop-up titles
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700, // Bold
          color: _textWhite,
        ),

        // 20px: Used for app bar titles or standard section headings
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600, // Semi-Bold
          color: _textWhite,
        ),

        // 16px: The absolute standard for reading body text (Do not go smaller for main text)
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500, // Medium
          color: _textWhite,
        ),

        // 12px: Used for tiny helper text, error messages, or timestamps
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400, // Regular
          color: _textGrey, // Using grey here so it doesn't distract the user
        ),
      ),

      // --- 4. GLOBAL TEXT FIELD STYLING ---
      // This forces every TextField in the app to look identical without repeating code.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark, // The #2C2C2C background inside the box
        hintStyle: GoogleFonts.plusJakartaSans(color: _textGrey, fontSize: 16),

        // Default state: No visible border, just the background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // Active state: The box glows purple when the user taps to type
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryPurple, width: 2),
        ),
      ),
    );
  }
}
