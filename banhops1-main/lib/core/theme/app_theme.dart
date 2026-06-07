import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // ─── Brand Colors ────────────────────────────────────────────
  static const Color primaryColor   = Color(0xFF0F4C81);
  static const Color secondaryColor = Color(0xFF1B998B);
  static const Color accentColor    = Color(0xFFF28E2B);
  static const Color accentLight    = Color(0xFFFFD166);
  static const Color successColor   = Color(0xFF22C55E);
  static const Color errorColor     = Color(0xFFEF4444);
  static const Color warningColor   = Color(0xFFF59E0B);

  // ─── Grey Scale ──────────────────────────────────────────────
  static const Color grey50  = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // ─── Spacing ─────────────────────────────────────────────────
  static const double spacingXs  = 4;
  static const double spacingSm  = 8;
  static const double spacingMd  = 16;
  static const double spacingLg  = 24;
  static const double spacingXl  = 32;
  static const double spacingXxl = 48;

  // ─── Border Radius ───────────────────────────────────────────
  static const double radiusSm   = 12;
  static const double radiusMd   = 16;
  static const double radiusLg   = 20;
  static const double radiusXl   = 24;
  static const double radiusRound = 100;

  // ─── Animation Durations ─────────────────────────────────────
  static const Duration animFast   = Duration(milliseconds: 180);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow   = Duration(milliseconds: 480);

  // ─── Gradients ───────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F4C81), Color(0xFF1B998B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF28E2B), Color(0xFFFFD166)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient surfaceGradient(BuildContext context) {
    final isDk = isDark(context);
    return LinearGradient(
      colors: isDk
          ? [const Color(0xFF0D1117), const Color(0xFF161B22)]
          : [const Color(0xFFF4F7FB), const Color(0xFFE7F1FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // ─── Shadows ─────────────────────────────────────────────────
  static List<BoxShadow> cardShadow(BuildContext context) {
    return isDark(context)
        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 6))]
        : [BoxShadow(color: const Color(0xFF0F4C81).withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))];
  }

  static const List<BoxShadow> navBarShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4)),
  ];

  // ─── Decorations ─────────────────────────────────────────────
  static BoxDecoration premiumCardDecoration(BuildContext context) {
    final isDk = isDark(context);
    return BoxDecoration(
      color: isDk ? const Color(0xFF151D2E) : Colors.white,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color: isDk ? Colors.white.withValues(alpha: 0.06) : grey200,
      ),
      boxShadow: cardShadow(context),
    );
  }

  static BoxDecoration glassDecoration(BuildContext context) {
    final isDk = isDark(context);
    return BoxDecoration(
      color: isDk
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.white.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color: isDk ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5),
      ),
      boxShadow: cardShadow(context),
    );
  }

  // ─── Helper ──────────────────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // ─── Light Theme ─────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFFF4F7FB),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Colors.white,
      error: Color(0xFFB3261E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1F2B),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFFCBD5E1),
      surfaceContainerHighest: Color(0xFFF1F5F9),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: Color(0xFF1A1F2B),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1F2B),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      shadowColor: const Color(0x11000000),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FBFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: const TextStyle(color: grey500, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: grey400),
    ),
    textTheme: const TextTheme(
      displaySmall:  TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF102033)),
      headlineMedium:TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF102033)),
      titleLarge:    TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
      titleMedium:   TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
      titleSmall:    TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1F2B)),
      bodyLarge:     TextStyle(fontSize: 16, color: Color(0xFF273244)),
      bodyMedium:    TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
      bodySmall:     TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF102033)),
      labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
      labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEAF2FF),
      selectedColor: primaryColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
    ),
    dividerTheme: const DividerThemeData(color: grey200, thickness: 1, space: 0),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primaryColor : grey300,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? primaryColor.withValues(alpha: 0.3)
            : grey200,
      ),
    ),
  );

  // ─── Dark Theme ──────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4D9FEC),
      secondary: Color(0xFF26C6B0),
      tertiary: accentColor,
      surface: Color(0xFF111827),
      error: Color(0xFFCF6679),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE8EDF3),
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF334155),
      surfaceContainerHighest: Color(0xFF1E293B),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: Color(0xFFE8EDF3),
      titleTextStyle: TextStyle(
        color: Color(0xFFE8EDF3),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF151D2E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4D9FEC),
        side: const BorderSide(color: Color(0xFF4D9FEC)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A2332),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: Color(0xFF4D9FEC), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: Color(0xFFCF6679)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: Color(0xFF475569)),
    ),
    textTheme: const TextTheme(
      displaySmall:  TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFFE8EDF3)),
      headlineMedium:TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFFE8EDF3)),
      titleLarge:    TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFE8EDF3)),
      titleMedium:   TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFFE8EDF3)),
      titleSmall:    TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFCDD5E0)),
      bodyLarge:     TextStyle(fontSize: 16, color: Color(0xFFB8C4D4)),
      bodyMedium:    TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
      bodySmall:     TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFE8EDF3)),
      labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
      labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E293B),
      selectedColor: primaryColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF1E293B), thickness: 1, space: 0),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? const Color(0xFF4D9FEC) : grey600,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? const Color(0xFF4D9FEC).withValues(alpha: 0.3)
            : grey800,
      ),
    ),
  );
}
