import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F4C81);
  static const Color secondaryColor = Color(0xFF1B998B);
  static const Color accentColor = Color(0xFFF28E2B);
  static const Color backgroundColor = Color(0xFFF4F7FB);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: Color(0xFFB3261E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1F2B),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Color(0xFF1A1F2B),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1F2B),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      shadowColor: const Color(0x11000000),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FBFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryColor, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF102033)),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF102033)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF273244)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEAF2FF),
      selectedColor: primaryColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
