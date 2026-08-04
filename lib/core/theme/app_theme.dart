// lib/core/theme/app_theme.dart
// Modern theme configuration for the AI Chat application

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// App theme provider with light and dark mode support
class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        color: AppColors.cardLight,
        surfaceTintColor: Colors.transparent,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: AppSpacing.paddingMd,
        hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),

      // Filled Button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondaryLight,
        ),
      ),

      // Drawer
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSpacing.radiusXl),
            bottomRight: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        color: AppColors.cardDark,
        surfaceTintColor: Colors.transparent,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        contentPadding: AppSpacing.paddingMd,
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
        ),
      ),

      // Filled Button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondaryDark,
        ),
      ),

      // Drawer
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSpacing.radiusXl),
            bottomRight: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        backgroundColor: AppColors.cardDark,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
    );
  }

  // Light color scheme
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFCCFBF1),
    onSecondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: Color(0xFFF1F5F9),
    onSurfaceVariant: AppColors.textSecondaryLight,
    outline: Color(0xFFCBD5E1),
  );

  // Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF3730A3),
    onPrimaryContainer: Color(0xFFE0E7FF),
    secondary: AppColors.secondaryLight,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFF164E63),
    onSecondaryContainer: Color(0xFFCCFBF1),
    tertiary: AppColors.accentLight,
    onTertiary: Colors.black,
    error: Color(0xFFFCA5A5),
    onError: Colors.black,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: Color(0xFF313244),
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: Color(0xFF45475A),
  );
}
