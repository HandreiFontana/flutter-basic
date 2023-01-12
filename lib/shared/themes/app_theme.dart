import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';

class AppThemes {
  static ThemeData mainTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 26,
      ),
      labelStyle: TextStyle(
        fontSize: 20,
        decorationColor: AppColors.primary,
      ),
    ),
    cardColor: AppColors.cardColor,
  );
}
