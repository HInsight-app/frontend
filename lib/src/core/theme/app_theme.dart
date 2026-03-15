import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _primaryBlue = Color(0xFF1E40AF);
  static const _backgroundBlue = Color(0xFFF8FAFC);

  static ThemeData get lightTheme {
    // Start by defining the base theme
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryBlue,
        primary: _primaryBlue,
        surface: _backgroundBlue,
        brightness: Brightness.light,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme).copyWith(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF0F172A),
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundBlue,
        centerTitle: false,
        elevation: 0,
      ),
    );
  }
}