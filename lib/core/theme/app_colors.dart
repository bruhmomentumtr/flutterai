// lib/core/theme/app_colors.dart
// Color palette for the AI Chat application

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6750A4);
  static const Color primaryLight = Color(0xFF6750A4);
  static const Color primaryDark = Color(0xFFD0BCFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color accent = Color(0xFF7D5260);
  static const Color accentLight = Color(0xFF7D5260);
  static const Color accentDark = Color(0xFFEFB8C8);

  static const Color surface = Color(0xFFFEF7FF);
  static const Color surfaceLight = Color(0xFFFEF7FF);
  static const Color surfaceDark = Color(0xFF141218);
  static const Color onSurface = Color(0xFF1D1B20);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  static const Color background = Color(0xFFFEF7FF);
  static const Color backgroundLight = Color(0xFFFEF7FF);
  static const Color backgroundDark = Color(0xFF141218);
  static const Color onBackground = Color(0xFF1D1B20);

  static const Color cardLight = Color(0xFFF7F2FA);
  static const Color cardDark = Color(0xFF1D1B20);

  static const Color textPrimaryLight = Color(0xFF1D1B20);
  static const Color textPrimaryDark = Color(0xFFE6E1E5);
  static const Color textSecondaryLight = Color(0xFF49454F);
  static const Color textSecondaryDark = Color(0xFFCAC4D0);

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);

  /// Primary brand gradient used for hero surfaces (e.g. animated bubbles).
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      accent,
    ],
  );
}
