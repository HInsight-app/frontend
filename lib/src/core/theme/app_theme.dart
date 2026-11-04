import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import 'app_colors.dart';

class AppTheme {
  // The private constructor `AppTheme._()` prevents anyone from accidentally
  // creating an instance of this class (e.g., `var theme = AppTheme()`).
  // We only want to access the static properties directly.
  AppTheme._();

  /// Must match the `family:` declared under `fonts:` in pubspec.yaml. The font
  /// files are bundled in assets/fonts/, so no network is needed to show them.
  static const fontFamily = 'PlusJakartaSans';

  // Radius for buttons and text fields. Cards use AppSizes.borderRadius.
  static const _controlRadius = 12.0;

  // --- 1. COLOR SCHEME ---
  // Maps the style guide (AppColors) onto Material's colour slots, so built-in
  // widgets pick the right colours without being told.
  static const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.foreground,
    // The style guide's "Button / CTA" colour. Filled buttons and the FAB use it.
    primaryContainer: AppColors.cta,
    onPrimaryContainer: AppColors.background,
    secondary: AppColors.secondary,
    onSecondary: AppColors.foreground,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.foreground,
    tertiary: AppColors.accent,
    onTertiary: AppColors.foreground,
    error: AppColors.error,
    onError: AppColors.background,
    errorContainer: Color(0x26FF6467), // AppColors.error at 15% opacity
    onErrorContainer: AppColors.error,
    surface: AppColors.background, // Scaffold and app bar background
    onSurface: AppColors.foreground,
    surfaceContainerLowest: AppColors.card,
    surfaceContainerLow: AppColors.card,
    surfaceContainer: AppColors.card,
    surfaceContainerHigh: AppColors.input,
    surfaceContainerHighest: AppColors.input,
    onSurfaceVariant: AppColors.mutedForeground, // Sub-text, hints, inactive icons
    outline: AppColors.border,
    outlineVariant: AppColors.border,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.foreground, // Default snackbar background
    onInverseSurface: AppColors.background,
    inversePrimary: AppColors.accent,
    // Stops Material 3 from tinting raised surfaces purple.
    surfaceTint: Colors.transparent,
  );

  // Every style sets the font itself: a TextStyle given straight to a widget
  // (like a button's) does not inherit ThemeData.fontFamily.
  static TextStyle _style(
    double size,
    FontWeight weight, [
    Color color = AppColors.foreground,
  ]) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
    );
  }

  // --- 2. TYPOGRAPHY ---
  // The style guide's scale is marked "Design"; the rest fill Material's slots.
  static final textTheme = TextTheme(
    headlineLarge: _style(32, FontWeight.w800), // Design: Title, Extrabold 32
    headlineMedium: _style(28, FontWeight.w700),
    headlineSmall: _style(24, FontWeight.w700), // Design: Heading 2, Bold 24
    titleLarge: _style(20, FontWeight.w600), // App bar titles
    titleMedium: _style(16, FontWeight.w600), // Card titles
    titleSmall: _style(14, FontWeight.w600), // Field labels
    bodyLarge: _style(16, FontWeight.w400), // Text typed into fields
    bodyMedium: _style(16, FontWeight.w400), // Design: Paragraph, Normal 16
    // Design: Sub-text, Light 14
    bodySmall: _style(14, FontWeight.w300, AppColors.mutedForeground),
    labelLarge: _style(14, FontWeight.w600),
    labelMedium: _style(12, FontWeight.w600), // Chips and badges
    labelSmall: _style(12, FontWeight.w400, AppColors.mutedForeground),
  );

  // --- 3. DARK THEME DEFINITION ---
  static ThemeData get darkTheme {
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_controlRadius),
    );
    final buttonText = _style(16, FontWeight.w700);
    const buttonMinimumSize = Size(64, 52);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(_controlRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: fontFamily,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: AppColors.foreground),

      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),

      // --- 4. BUTTONS ---
      // Filled buttons use the CTA colour with dark text (about 11:1 contrast).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cta,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.secondary,
          disabledForegroundColor: AppColors.mutedForeground,
          elevation: 0,
          minimumSize: buttonMinimumSize,
          shape: controlShape,
          textStyle: buttonText,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cta,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.secondary,
          disabledForegroundColor: AppColors.mutedForeground,
          minimumSize: buttonMinimumSize,
          shape: controlShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          side: const BorderSide(color: AppColors.border),
          minimumSize: buttonMinimumSize,
          shape: controlShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: _style(14, FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.cta,
        foregroundColor: AppColors.background,
        elevation: 0,
        highlightElevation: 0,
        extendedTextStyle: _style(16, FontWeight.w600),
      ),

      // --- 5. GLOBAL TEXT FIELD STYLING ---
      // Forces every TextField in the app to look identical without repeating code.
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.input,
        hintStyle: _style(16, FontWeight.w400, AppColors.mutedForeground),
        contentPadding: const EdgeInsets.all(16),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.mutedForeground,
        border: inputBorder(AppColors.border),
        enabledBorder: inputBorder(AppColors.border),
        // The style guide's "Ring" colour shows which field is active.
        focusedBorder: inputBorder(AppColors.ring, 2),
        errorBorder: inputBorder(AppColors.error),
        focusedErrorBorder: inputBorder(AppColors.error, 2),
      ),

      // --- 6. SURFACES AND SMALL COMPONENTS ---
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary,
        labelStyle: textTheme.labelMedium,
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: controlShape,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.secondary,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.secondary,
        thumbColor: AppColors.primary,
      ),
      // Bottom navigation, as in the mockups: the active tab is a primary pill.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.primary,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.foreground
                : AppColors.mutedForeground,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => _style(
            12,
            FontWeight.w600,
            states.contains(WidgetState.selected)
                ? AppColors.foreground
                : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
