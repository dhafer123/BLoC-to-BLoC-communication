import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const ink = Color(0xFF172121);
    const paper = Color(0xFFF7F5EF);
    const coral = Color(0xFFE07A5F);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: coral,
        brightness: Brightness.light,
        surface: paper,
      ),
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: ink,
          fontSize: 42,
          fontWeight: FontWeight.w700,
          height: 0.98,
        ),
        headlineSmall: TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: ink, fontSize: 16, height: 1.4),
        bodyMedium: TextStyle(color: Color(0xFF53605F), fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
