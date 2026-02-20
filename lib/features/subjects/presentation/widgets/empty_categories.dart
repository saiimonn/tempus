import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class EmptyCategories extends StatelessWidget {
  const EmptyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            "No grade categories yet",
            style: TextStyle(color: AppColors.foreground, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
