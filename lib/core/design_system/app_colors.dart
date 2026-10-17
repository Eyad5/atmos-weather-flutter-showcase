import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color brandCyan = Color(0xFF06B6D4);

  // Sky gradients – light mode
  static const List<Color> skyLight = [
    Color(0xFFD4E6FF),
    Color(0xFFE8F1FF),
    Color(0xFFF5F9FF),
  ];

  // Sky gradients – dark mode
  static const List<Color> skyDark = [
    Color(0xFF0A1628),
    Color(0xFF0F1F3B),
    Color(0xFF152644),
  ];

  // Weather condition gradients
  static const List<Color> sunnyGradient = [
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
    Color(0xFF3B82F6),
  ];
  static const List<Color> partlyCloudyGradient = [
    Color(0xFF60A5FA),
    Color(0xFF93C5FD),
    Color(0xFF3B82F6),
  ];
  static const List<Color> cloudyGradient = [
    Color(0xFF94A3B8),
    Color(0xFF64748B),
    Color(0xFF475569),
  ];
  static const List<Color> rainyGradient = [
    Color(0xFF475569),
    Color(0xFF334155),
    Color(0xFF1E293B),
  ];
  static const List<Color> stormyGradient = [
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
    Color(0xFF1E1B4B),
  ];
  static const List<Color> snowyGradient = [
    Color(0xFFBFDBFE),
    Color(0xFFDBEAFE),
    Color(0xFF93C5FD),
  ];
  static const List<Color> foggyGradient = [
    Color(0xFF9CA3AF),
    Color(0xFFD1D5DB),
    Color(0xFF9CA3AF),
  ];
  static const List<Color> nightGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF0F172A),
  ];
  static const List<Color> defaultGradient = [
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
    Color(0xFF2563EB),
  ];

  // Card surface colors
  static Color cardLight = Colors.white.withAlpha(200);
  static Color cardDark = Colors.white.withAlpha(18);

  // Overlay text on gradients
  static const Color onGradient = Colors.white;
  static Color onGradientSecondary = Colors.white.withAlpha(190);
  static Color onGradientTertiary = Colors.white.withAlpha(140);
}
