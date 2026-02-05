import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppInputTheme {
  static InputDecoration loginInputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _outlineBorder(),
      enabledBorder: _outlineBorder(color: Colors.transparent),
      focusedBorder: _outlineBorder(color: AppColors.brandBlue, width: 2),
    );
  }

  static OutlineInputBorder _outlineBorder({Color color = Colors.transparent, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}