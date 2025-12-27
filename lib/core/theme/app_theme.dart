import 'package:flutter/material.dart';

/// App theme configuration with kid-friendly colors
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A90E2), // Bright blue
        primary: const Color(0xFF4A90E2),
        secondary: const Color(0xFFFF9800), // Orange
      ),
    );
  }
}

