import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';

class ScoreTile extends StatelessWidget {
  final ScoresEntity score;
  final VoidCallback onDelete;

  const ScoreTile({
    super.key,
    required this.score,
    required this.onDelete,
  });

  String _fmt(double v) => 
    v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  double get _percent =>
    score.maxScore > 0 ? score.scoreValue / score.maxScore : 0;

  Color get _percentColor {
    final p = _percent;
    if (p >= 0.85) return AppColors.success;
    if (p >= 0.70) return const Color(0xFFF59E0B);
    return AppColors.destructive;
  }

  @override
  Widget build(BuildContext context) {
    final pct = _percent;
    final color = _percentColor;

    return Dismissible(
      key: Key('score_${score.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.destructive,
          size: 22,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 2.5,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ),
            ),

            const Gap(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),

                  Text(
                    '${_fmt(score.scoreValue)} / ${_fmt(score.maxScore)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '${(pct * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}