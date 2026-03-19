import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 48.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),

    headlineMedium: const TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),

    headlineSmall: const TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),

    titleLarge: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),

    titleMedium: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),

    titleSmall: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),

    bodyLarge: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),

    bodyMedium: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),

    bodySmall: const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),
  );
}

extension CustomText on TextTheme {
  TextStyle get headlineLargeEmp =>
      headlineLarge!.copyWith(fontWeight: FontWeight.w500);
}
