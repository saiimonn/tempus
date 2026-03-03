import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';

class BudgetRing extends StatelessWidget {
  final FinanceEntity finance;
  final VoidCallback onEditBudget;

  const BudgetRing({
    super.key,
    required this.finance,
    required this.onEditBudget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = finance.budgetProgress;
    final leftToSpend = finance.totalAmount;
    final weeklyAllowance = finance.weeklyAllowance;

    Color ringColor;
    if (progress <= 0.5) {
      ringColor = AppColors.success;
    } else if (progress <= 0.8) {
      ringColor = const Color(0xFFF59E0B);
    } else {
      ringColor = AppColors.destructive;
    }

    return Column(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(160, 160),
                painter: _RingPainter(
                  progress: progress,
                  color: ringColor,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Left to spend',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Gap(4),

                  Text(
                    '₱${leftToSpend.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Gap(12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'of ₱${weeklyAllowance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12, color: AppColors.foreground),
            ),

            const Gap(6),

            GestureDetector(
              onTap: onEditBudget,
              child: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.brandBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final fgPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
