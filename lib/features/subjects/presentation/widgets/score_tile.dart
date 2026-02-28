import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(40))),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
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
            '${((score.scoreValue / score.maxScore) * 100).toStringAsFixed(0)}`%`',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _percentColor(score.percent),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline,
                size: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Color _percentColor(double percent) {
    if (percent >= 0.85) return AppColors.success;
    if (percent >= 0.70) return const Color(0xFFF59E0B);
    return AppColors.destructive;
  }
}