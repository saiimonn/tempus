// used in schedul_page.dart -> ScheduleContent()
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';

class EmptySchedule extends StatelessWidget {
  final List<Map<String, dynamic>> subject;

  const EmptySchedule({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 60,
            color: AppColors.foreground.withValues(alpha: 0.5),
          ),

          const Gap(16),

          const Text(
            "No classes scheduled yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),

          const Text(
            "Tap 'Add Class' to get started",
            style: TextStyle(
              fontSize: 12, 
              color: AppColors.foreground, 
              fontWeight: FontWeight.w500
            ),
          ),
        ]
      )
    );
  }
}