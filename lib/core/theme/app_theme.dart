import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.neon,
        surface: AppColors.card,
        error: AppColors.wrong,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: AppTypography.display(fontSize: 30),
        headlineMedium: AppTypography.display(fontSize: 24),
        titleLarge: AppTypography.display(fontSize: 20),
        titleMedium: AppTypography.body(fontSize: 16, fontWeight: FontWeight.w700),
        bodyLarge: AppTypography.body(fontSize: 16),
        bodyMedium: AppTypography.body(fontSize: 14),
        bodySmall: AppTypography.body(fontSize: 12, color: AppColors.mutedForeground),
      ),
    );
  }
}
