// lib/core/theme/app_colors.dart
// Modern color palette for the AI Chat application

import 'package:flutter/material.dart';

/// App color palette with beautiful gradients and modern colors
class AppColors {
  AppColors._();

  // Primary Colors - Deep Purple/Blue gradient theme
  static const Color primaryLight = Color(0xFF6366F1); // Indigo
  static const Color primary = Color(0xFF4F46E5); // Primary indigo
  static const Color primaryDark = Color(0xFF4338CA); // Darker indigo

  // Secondary Colors - Teal/Cyan accents
  static const Color secondaryLight = Color(0xFF22D3EE); // Cyan
  static const Color secondary = Color(0xFF06B6D4); // Teal
  static const Color secondaryDark = Color(0xFF0891B2); // Darker teal

  // Accent Colors
  static const Color accent = Color(0xFFF472B6); // Pink
  static const Color accentLight = Color(0xFFFBCFE8); // Light pink

  // Surface Colors - Light Mode
  static const Color surfaceLight = Color(0xFFFAFAFC);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Surface Colors - Dark Mode
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF11111B);
  static const Color cardDark = Color(0xFF181825);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Message Bubble Colors
  static const Color userBubbleLight = Color(0xFF4F46E5);
  static const Color userBubbleDark = Color(0xFF6366F1);
  static const Color aiBubbleLight = Color(0xFFF1F5F9);
  static const Color aiBubbleDark = Color(0xFF1E293B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient welcomeGradient = LinearGradient(
    colors: [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkWelcomeGradient = LinearGradient(
    colors: [
      Color(0xFF1E1E2E),
      Color(0xFF2D1B4E),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glassmorphism colors
  static Color glassLight = Colors.white.withOpacity(0.25);
  static Color glassDark = Colors.white.withOpacity(0.1);
  static Color glassBorderLight = Colors.white.withOpacity(0.3);
  static Color glassBorderDark = Colors.white.withOpacity(0.15);
}
