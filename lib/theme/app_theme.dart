import 'package:flutter/material.dart';

import 'custom_colors_theme.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF); // Electric Blue
  static const Color accentColor = Color(0xFF795548); // Brown
  static const Color backgroundColor =
      Color.fromARGB(255, 255, 255, 255); // Soft Cream
  static const Color surfaceColor = Color(0xFFF5F5F5); // Light Gray
  static const Color textColor = Color(0xFF1A1A2E); // Deep Navy

  static ThemeData get() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: textColor,
        onSurface: textColor,
      ),
      extensions: [
        CustomColorsTheme(
          colorLabelColor: Colors.grey.shade700,
          bottomNavigationBarBackgroundColor: Colors.white,
          activeNavigationBarColor: primaryColor,
          notActiveNavigationBarColor: Colors.grey,
          shadowNavigationBarColor: Colors.black.withOpacity(0.1),
        )
      ],
    );
  }
}
