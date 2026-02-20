//used in scores_page -> _buildContent()
import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/presentation/widgets/score_tile.dart';

class CategorySection extends StatelessWidget {
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> scores;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddScore;
  final void Function(int scoreId) onDeleteScore;

  const CategorySection({
    super.key,
    required this.category,
    required this.scores,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddScore,
    required this.onDeleteScore,
  });

  @override
  Widget build(BuildContext build) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: isExpanded
              ? const BorderRadius.vertical(top: Radius.circular(12))
              : BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${category['name']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onAddScore,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.add, size: 20, color: AppColors.brandBlue),
                    ),
                  ),

                  const SizedBox(width: 4),

                  Icon(
                    isExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                    size: 22,
                    color: AppColors.foreground,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)...[
            Divider (
              height: 1,
              color: Colors.grey.withValues(alpha: 60),
              indent: 16,
              endIndent: 16,
            ),

            if (scores.isEmpty)
              _buildNoScores()
            else
              ...scores.map(
                (score) => ScoreTile(
                  score: score,
                  onDelete: () => onDeleteScore(score['id'] as int),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoScores() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 36,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),
          
          const SizedBox(height: 8),

          const Text(
            "No Scores Found",
            style: TextStyle(color: AppColors.foreground, fontSize: 13)
          ),
        ],
      ),
    );
  }
}