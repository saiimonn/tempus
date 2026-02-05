import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class RequiredLabel extends StatelessWidget {
  final String text;

  const RequiredLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text.replaceAll('*', '').trim(),
        style: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        children: [
          if (text.contains('*'))
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.destructive),
          ),
        ],
      ),
    );
  }
}