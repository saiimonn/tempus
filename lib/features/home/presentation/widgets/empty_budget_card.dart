import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyBudgetCard extends StatelessWidget {
  const EmptyBudgetCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WText(
                "Remaining Budget",
                className: "font-xl font-bold text-blue-800",
              ),
              const Text(
                "₱0",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.05,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandBlue),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),

          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Spent: ₱0", style: TextStyle(fontSize: 12)),
              Text("Weekly Limit: ₱5,000", style: TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            "Your wallet is currently empty, log a response.",
            style: TextStyle(color: AppColors.destructive, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
