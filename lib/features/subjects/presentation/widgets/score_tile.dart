// used in category_section -> build()
import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class ScoreTile extends StatelessWidget {
  final Map<String, dynamic> score;
  final VoidCallback onDelete;

  const ScoreTile({
    super.key,
    required this.score,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final double scoreValue = ((score['score_value'] ?? 0.0) as num).toDouble();
    final double maxValue = ((score['max_score'] ?? 1.0) as num).toDouble();
    final double percent = maxValue > 0 ? scoreValue / maxValue : 0;

    String fmt(double v) => v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

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
                  "${score['title']}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "${fmt(scoreValue)} / ${fmt(maxValue)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "${(percent * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _percentColor(percent),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade400)
          ),
        ],
      ),
    );
  }

  Color _percentColor(double percent) {
    if(percent >= 0.85) return AppColors.success;
    if(percent >= 0.70) return const Color(0xFFF59E0B);
    return AppColors.destructive; 
  }
}