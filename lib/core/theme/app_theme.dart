import 'package:flutter/material.dart';

class AppTheme {
  // A professional, deep and vibrant orange accent color
  static const Color accentOrange = Color(0xFFF57C00);

  // Dark mode colors extracted from the current app
  static const Color darkBackground = Color(0xFF121417);
  static const Color darkCard = Color(0xFF1E2125);

  // Light mode subtle colors
  static const Color lightBackground = Color.fromARGB(255, 238, 238, 238);
  static const Color lightCard = Colors.white;

  // ---------- Text Colors ----------

  // Light
  static const Color lightTextPrimary = Color(0xFF1C1E21);
  static const Color lightTextSecondary = Color(0xFF5F6368);
  static const Color lightTextTertiary = Color(0xFF9AA0A6);
  static const Color lightTextDisabled = Color(0xFFB0B4B9);

  // Dark
  static const Color darkTextPrimary = Color(0xFFE3E6EB);
  static const Color darkTextSecondary = Color(0xFFB0B5BD);
  static const Color darkTextTertiary = Color(0xFF8A8F98);
  static const Color darkTextDisabled = Color(0xFF5F6368);

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: accentOrange,
            primary: accentOrange,
            brightness: Brightness.light,
            surface: lightCard,
          ).copyWith(
            surface: lightCard, // or darkCard
            onSurface: lightTextPrimary, // or darkTextPrimary
          ),
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: lightTextPrimary),
        displayMedium: TextStyle(color: lightTextPrimary),
        displaySmall: TextStyle(color: lightTextPrimary),

        headlineLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(color: lightTextPrimary),
        headlineSmall: TextStyle(color: lightTextPrimary),

        titleLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
        ),
        titleSmall: TextStyle(color: lightTextSecondary),

        bodyLarge: TextStyle(color: lightTextPrimary),
        bodyMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodySmall: TextStyle(color: lightTextTertiary),

        labelLarge: TextStyle(color: lightTextPrimary, fontSize: 16),
        labelMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        labelSmall: TextStyle(color: lightTextDisabled, fontSize: 10),
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: accentOrange,
            primary: accentOrange,
            brightness: Brightness.dark,
            surface: darkCard,
          ).copyWith(
            surface: lightCard, // or darkCard
            onSurface: lightTextPrimary, // or darkTextPrimary
          ),
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkTextPrimary),
        displayMedium: TextStyle(color: darkTextPrimary),
        displaySmall: TextStyle(color: darkTextPrimary),

        headlineLarge: TextStyle(color: darkTextPrimary),
        headlineMedium: TextStyle(color: darkTextPrimary),
        headlineSmall: TextStyle(color: darkTextPrimary),

        titleLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        titleSmall: TextStyle(color: darkTextSecondary),

        bodyLarge: TextStyle(color: darkTextPrimary),
        bodyMedium: TextStyle(color: darkTextSecondary),
        bodySmall: TextStyle(color: darkTextTertiary),

        labelLarge: TextStyle(color: darkTextPrimary),
        labelMedium: TextStyle(color: darkTextSecondary),
        labelSmall: TextStyle(color: darkTextDisabled),
      ),
    );
  }
}
