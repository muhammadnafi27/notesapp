import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemaAplikasi {
  static const Color warnaOranye = Color(0xFFFF6B00);
  static const Color warnaOranye2 = Color(0xFFFF8C38);
  static const Color warnaLatarBelakang = Color(0xFF0F0F0F);
  static const Color warnaPermukaan = Color(0xFF1A1A1A);
  static const Color warnaPermukaan2 = Color(0xFF242424);
  static const Color warnaPermukaan3 = Color(0xFF2E2E2E);
  static const Color warnaKartu = Color(0xFF1E1E1E);
  static const Color warnaTeks = Color(0xFFF5F5F5);
  static const Color warnaTeksSekunder = Color(0xFF9E9E9E);

  // Semi-transparent orange variants (alpha pre-baked)
  static const Color orangeA10 = Color(0x1AFF6B00);
  static const Color orangeA15 = Color(0x26FF6B00);
  static const Color orangeA20 = Color(0x33FF6B00);
  static const Color orangeA30 = Color(0x4DFF6B00);
  static const Color orangeA40 = Color(0x66FF6B00);
  static const Color orangeA50 = Color(0x80FF6B00);

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: warnaLatarBelakang,
      colorScheme: const ColorScheme.dark(
        primary: warnaOranye,
        secondary: warnaOranye2,
        surface: warnaPermukaan,
        onSurface: warnaTeks,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        headlineLarge: GoogleFonts.inter(
          color: warnaTeks,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        headlineMedium: GoogleFonts.inter(
          color: warnaTeks,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleLarge: GoogleFonts.inter(
          color: warnaTeks,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: GoogleFonts.inter(
          color: warnaTeks,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.inter(color: warnaTeks, fontSize: 16),
        bodyMedium: GoogleFonts.inter(
          color: warnaTeksSekunder,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: warnaLatarBelakang,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: warnaTeks,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: warnaTeks),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: warnaOranye,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: warnaPermukaan2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: warnaOranye, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: warnaTeksSekunder),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: warnaKartu,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
