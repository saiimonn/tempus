import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';

class HomeBudgetCard extends StatelessWidget {
  final FinanceEntity? finance;

  const HomeBudgetCard({super.key, required this.finance});

  @override
  Widget build(BuildContext context) {
    if (finance == null || finance!.weeklyAllowance == 0) {
      return _buildEmptyState();
    }

    return _buildFilledState(finance!);
  }

  Widget _buildFilledState(FinanceEntity finance) {
    final progress = finance.budgetProgress.clamp(0.0, 1.0);
    final remaining = finance.totalAmount;
    final spent = finance.spentThisWeek.clamp(0.0, double.infinity);
    final weekly = finance.weeklyAllowance;
    final isWarning = progress > 0.8;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isWarning
          ? Border.all(color: AppColors.destructive.withValues(alpha: 0.4), width: 1.5)
          : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isWarning) 
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.destructive,
                      ),
                    ),
                  Text(
                    "Remaining Budget",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isWarning
                        ? AppColors.destructive
                        : AppColors.brandBlue,
                    ),
                  ),
                ],
              ),
              
              Text(
                '₱${remaining.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          
          const Gap(10),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isWarning ? AppColors.destructive : AppColors.brandBlue,
              ),
            ),
          ),
          
          const Gap(10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Spent ₱${spent.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.foreground,
                ),
              ),
              
              Text(
                "Weekly Limit: ₱${weekly.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Remaining Budget",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandBlue,
                ),
              ),

              Text(
                "₱0",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),

          const Gap(10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.0,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.brandBlue,
              ),
            ),
          ),

          const Gap(10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ₱0',
                style: TextStyle(fontSize: 12, color: AppColors.foreground),
              ),

              Text(
                'Weekly Limit: ₱0',
                style: TextStyle(fontSize: 12, color: AppColors.foreground),
              ),
            ],
          ),

          const Gap(10),

          const Text(
            "Your finances haven't been set up yet",
            style: TextStyle(fontSize: 12, color: AppColors.destructive),
          ),
        ],
      ),
    );
  }
}
