import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final paper = isDark ? const Color(0xFF172121) : const Color(0xFFF7F5EF);
    final ink = isDark ? const Color(0xFFF7F5EF) : const Color(0xFF172121);
    final coral = isDark ? const Color(0xFFF29A7C) : const Color(0xFFE07A5F);
    final scheme = ColorScheme.fromSeed(
      seedColor: coral,
      brightness: brightness,
      surface: paper,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: scheme,
      textTheme: GoogleFonts.dmSansTextTheme(
        TextTheme(
          displaySmall: TextStyle(
            color: ink,
            fontFamily: GoogleFonts.dmSerifDisplay().fontFamily,
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
          bodyMedium: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
