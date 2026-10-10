import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color primaryPurple = Color(0xFF6750A4);
  static const Color lightPurple = Color(0xFFEDE7F6);
  static const Color darkPurple = Color(0xFF4A3685);

  // Accent colors
  static const Color amber = Color(0xFFF5B84B);
  static const Color coral = Color(0xFFE65366);

  // Background colors
  static const Color background = Color(0xFFF8F7FC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text colors
  static const Color black = Color(0xFF201A2C);
  static const Color textPrimary = Color(0xFF201A2C);
  static const Color textSecondary = Color(0xFF716B7C);
  static const Color hintText = Color(0xFF9A94A5);

  // Border and divider
  static const Color border = Color(0xFFE9E5F0);
  static const Color divider = Color(0xFFE9E5F0);

  // Status colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFF5B84B);
  static const Color info = Color(0xFF1976D2);

  // Gradients
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryPurple, darkPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
