import 'package:flutter/material.dart';
class AppTheme {
  static ThemeData dark({bool neon = false}) {
    final accent = neon ? const Color(0xFF00F0FF) : const Color(0xFFF5C044);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0B0F),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent, brightness: Brightness.dark, primary: accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0B0F), elevation: 0, centerTitle: true,
      ),
      useMaterial3: true,
    );
  }
}