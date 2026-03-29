import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//The main theme being applied to the app
class AppTheme {
  static const Color appBg = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D27);
  static const Color card = Color(0xFF22263A);
  static const Color elevated = Color(0xFF2C3050);
  static const Color primary = Color(0xFF6C63FF);
  static const Color accent = Color(0xFF4ECDC4);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8B8FA8);
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);

  static ThemeData get dark => ThemeData( //creating a new theme
    brightness: Brightness.dark,
    scaffoldBackgroundColor: appBg,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.dark(
      surface: surface,
      primary: primary,
      secondary: accent,
      error: danger,
    ),

    cardColor: card,

    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
    ),

    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textMuted),
    ),
  );
}