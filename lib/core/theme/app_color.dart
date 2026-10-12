import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryPurple = Color(0xFF7B2FF7);
  static const Color lightPurple = Color(0xFFEDE7F6);
  static const Color secondaryPurple = Color.fromARGB(255, 120, 181, 230);
  static const Color primaryPink = Color(0xFFFF6CAB);
  static const Color lightPink = Color(0xFFFF8CC6);
  static const Color coral = Color(0xFFE65366);
  static const Color amber = Color(0xFFF5B84B);

  static const Color background = Color(0xFFF8F5FF);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1F1F1F);
  static const Color grey = Color(0xFF808080);

  static const Color textSecondary = Color(0xFF6E6875);
  static const Color textTertiary = Color(0xFF8A8490);
  static const Color border = Color(0xFFE8E1EE);
  static const Color illustrationBackground = Color(0xFFEDE3FA);
  static const Color illustrationCircle = Color(0xFFDCCAF3);
  static const Color accentYellow = Color(0xFFFFD580);
  static const Color accentBrown = Color(0xFF7A4C12);
  static const Color accentCoral = Color(0xFFE88B78);
  static const Color errorBackground = Color(0xFFFFECE8);
  static const Color errorText = Color(0xFF9E3D2E);
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color primaryPurpleShadow = Color(0x267B2FF7);

  // Gradients
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryPurple, darkPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryPurple, secondaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
