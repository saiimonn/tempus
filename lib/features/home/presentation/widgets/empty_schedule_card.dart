import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyScheduleCard extends StatelessWidget {
  const EmptyScheduleCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText("Classes Today", className: "text-lg font-bold text-blue-600"),

          const SizedBox(height: 20),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_stories,
                  size: 60,
                  color: AppColors.foreground.withValues(alpha: 0.5),
                ),

                const SizedBox(height: 16),

                WText(
                  "No classes scheduled today",
                  className: "text-lg text-neutral-500 font-bold",
                ),
                Text(
                  "Enjoy your free time.",
                  style: TextStyle(fontSize: 12, color: AppColors.foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
