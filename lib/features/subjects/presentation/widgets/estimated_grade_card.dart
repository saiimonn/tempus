import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class EstimatedGradeCard extends StatelessWidget {
  final double grade;

  const EstimatedGradeCard({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      
      child: Column(
        children: [
          const Text(
            "Current Estimated Grade",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 6),
          
          Text(
            grade.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
