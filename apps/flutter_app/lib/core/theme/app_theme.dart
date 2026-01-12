// CareAccess Theme (Material 3)
// Generated for Melken TechWork - CareAccess SaaS
// Usage: import 'app_theme.dart'; ThemeData theme = CareAccessTheme.light();

import 'package:flutter/material.dart';

class CareAccessColors {
  // Core palette (brand)
  static const Color teal = Color(0xFF1F6F78);
  static const Color navy = Color(0xFF243A5E);

  // Supporting neutrals / accents
  static const Color sage = Color(0xFF9DB8A0);
  static const Color warmGray = Color(0xFF6B7280);
  static const Color sand = Color(0xFFF4F1EC);

  // Semantic colors (use sparingly; prefer system defaults where possible)
  static const Color success = Color(0xFF1F8A70);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const Color background = Color(0xFFF7FAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
}

class CareAccessTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: CareAccessColors.teal,
      brightness: Brightness.light,
    ).copyWith(
      primary: CareAccessColors.teal,
      secondary: CareAccessColors.navy,
      surface: CareAccessColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CareAccessColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: _textTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CareAccessColors.sand.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: CareAccessColors.warmGray.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: CareAccessColors.warmGray.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: CareAccessColors.teal, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: CareAccessColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CareAccessColors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CareAccessColors.navy,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: CareAccessColors.navy.withOpacity(0.35)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: CareAccessColors.sand.withOpacity(0.6),
        selectedColor: CareAccessColors.teal.withOpacity(0.18),
        labelStyle: const TextStyle(color: CareAccessColors.navy),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: DividerThemeData(
        color: CareAccessColors.warmGray.withOpacity(0.18),
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: CareAccessColors.teal,
      brightness: Brightness.dark,
    ).copyWith(
      primary: CareAccessColors.teal,
      secondary: CareAccessColors.sage,
      surface: CareAccessColors.darkSurface,
      surfaceContainerHighest: CareAccessColors.darkSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CareAccessColors.darkBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: _textThemeDark(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CareAccessColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: CareAccessColors.warmGray.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: CareAccessColors.warmGray.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: CareAccessColors.teal, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: CareAccessColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CareAccessColors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CareAccessColors.sage,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: CareAccessColors.sage.withOpacity(0.35)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: CareAccessColors.darkSurfaceVariant,
        selectedColor: CareAccessColors.teal.withOpacity(0.18),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: DividerThemeData(
        color: CareAccessColors.warmGray.withOpacity(0.18),
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme() {
    // Prefer Inter if added to pubspec; otherwise uses system fallback.
    return const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: CareAccessColors.navy),
      headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: CareAccessColors.navy),
      titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: CareAccessColors.navy),
      titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CareAccessColors.navy),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: CareAccessColors.navy),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CareAccessColors.navy),
      labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: CareAccessColors.navy),
    );
  }

  static TextTheme _textThemeDark() {
    // Dark mode text theme with lighter colors
    return const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
      headlineMedium: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white70),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}

// Legacy compatibility - keep AppTheme class for existing code
class AppTheme {
  static ThemeData get lightTheme => CareAccessTheme.light();
  static ThemeData get darkTheme => CareAccessTheme.dark();
}
