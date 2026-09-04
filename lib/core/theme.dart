import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Brand palette ─────────────────────────────────────────────────────────
  static const Color _primaryLight = Color(0xFF1565C0);
  static const Color _primaryDark  = Color(0xFF90CAF9);

  // Explicit surface colors used by both CardTheme and Scaffold
  static const Color _surfaceLight = Color(0xFFF8F9FA);
  static const Color _surfaceDark  = Color(0xFF121212);
  static const Color _cardLight    = Color(0xFFFFFFFF);
  static const Color _cardDark     = Color(0xFF1E1E1E);

  // ── Category status colors ─────────────────────────────────────────────────
  static const Color info        = Color(0xFF4CAF50); // 1xx
  static const Color success     = Color(0xFF2196F3); // 2xx
  static const Color redirect    = Color(0xFFFF9800); // 3xx
  static const Color clientError = Color(0xFFF44336); // 4xx
  static const Color serverError = Color(0xFFB71C1C); // 5xx

  /// Converts a "#RRGGBB" hex string → Flutter [Color].
  static Color colorFromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    // Always prepend full-opacity alpha
    return Color(int.parse('ff$cleaned', radix: 16));
  }

  // ── Text themes ───────────────────────────────────────────────────────────
  // We do NOT bake in explicit colors here. Instead we let Material3
  // ColorScheme drive text colors via textTheme. Individual screens
  // override color via copyWith() when needed. This ensures dark/light
  // both work without any manual brightness checks in the UI layer.
  static TextTheme _baseTextTheme() {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 28, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }

  // ── Light Theme ───────────────────────────────────────────────────────────
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryLight,
      brightness: Brightness.light,
      surface: _surfaceLight,
      onSurface: const Color(0xFF1A1A2E),
    ),
    scaffoldBackgroundColor: _surfaceLight,
    textTheme: _baseTextTheme(),
    cardTheme: CardThemeData(
      color: _cardLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Let Material3 drive AppBar colors from ColorScheme — no hardcoding
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: _surfaceLight,
      foregroundColor: const Color(0xFF1A1A2E),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A2E),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _cardLight,
      indicatorColor: _primaryLight.withValues(alpha: 0.12),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEEEEEE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryLight, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
  );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryDark,
      brightness: Brightness.dark,
      surface: _surfaceDark,
      onSurface: const Color(0xFFE0E0E0),
    ),
    scaffoldBackgroundColor: _surfaceDark,
    textTheme: _baseTextTheme(),
    cardTheme: CardThemeData(
      color: _cardDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: _surfaceDark,
      foregroundColor: const Color(0xFFE0E0E0),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFE0E0E0),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _cardDark,
      indicatorColor: _primaryDark.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryDark, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A2A),
      thickness: 1,
    ),
  );
}
