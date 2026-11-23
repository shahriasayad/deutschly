import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF1D4ED8);
  static const Color primaryDark = Color(0xFF60A5FA);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFFD97706);
  static const Color accent = Color(0xFF0F9D58);

  // Subtle German brand accents
  static const Color germanInk = Color(0xFF181C24);
  static const Color germanRed = Color(0xFFDC2626);
  static const Color germanGold = Color(0xFFF59E0B);

  static const Color backgroundLight = Color(0xFFF7F6F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceTintLight = Color(0xFFEFECE5);
  static const Color textPrimaryLight = Color(0xFF141A29);
  static const Color textSecondaryLight = Color(0xFF525C70);
  static const Color borderLight = Color(0xFFE4E1D8);

  static const Color backgroundDark = Color(0xFF0D111A);
  static const Color surfaceDark = Color(0xFF161C29);
  static const Color surfaceTintDark = Color(0xFF1F2738);
  static const Color textPrimaryDark = Color(0xFFF3F5F9);
  static const Color textSecondaryDark = Color(0xFF9BA6BC);
  static const Color borderDark = Color(0xFF283145);

  static const Color background = backgroundLight;
  static const Color surface = surfaceLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color border = borderLight;

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE8EEFF),
      onPrimaryContainer: const Color(0xFF14358A),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFEF3C7),
      onSecondaryContainer: const Color(0xFF78350F),
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      surfaceContainerHighest: surfaceTintLight,
      error: error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        indicatorColor: colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      dividerColor: borderLight,
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryDark,
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: const Color(0xFF0A1936),
      primaryContainer: const Color(0xFF1E325C),
      onPrimaryContainer: const Color(0xFFDCE8FF),
      secondary: germanGold,
      onSecondary: const Color(0xFF2B1800),
      secondaryContainer: const Color(0xFF3A2A12),
      onSecondaryContainer: const Color(0xFFFDE68A),
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      surfaceContainerHighest: surfaceTintDark,
      error: const Color(0xFFF87171),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      dividerColor: borderDark,
    );
  }
}
