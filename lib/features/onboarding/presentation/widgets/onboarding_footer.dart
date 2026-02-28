import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class OnboardingFooter extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onSkipOrDone;
  final VoidCallback onNext;

  const OnboardingFooter({
    super.key,
    required this.isLastPage,
    required this.onSkipOrDone,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(isLastPage ? "Done" : "Skip", onSkipOrDone),

        if(isLastPage) 
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.brandBlue,
              size: 28,
            ),
            onPressed: onSkipOrDone,
          )
        else 
          TextButton(
            onPressed: onNext,
            child: const Row(
              children: [
                Text(
                  "Next",
                  style: TextStyle(color: AppColors.brandBlue, fontSize: 16),
                ),
                Icon(Icons.chevron_right, color: AppColors.brandBlue, size: 20),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFADC4F3),
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}