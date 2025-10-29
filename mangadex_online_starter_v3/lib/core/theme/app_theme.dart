import 'package:flutter/material.dart';

class AppTheme {
  /// Tema oscuro (dorado por defecto; neón alternativo)
  static ThemeData dark({bool neon = false}) {
    final seed = neon ? const Color(0xFF00FFFF) : const Color(0xFFFFC107);

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      useMaterial3: true,
    );
  }
}

