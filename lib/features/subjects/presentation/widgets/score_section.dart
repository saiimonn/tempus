import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/presentation/widgets/score_tile.dart';

class ScoreSection extends StatelessWidget {
  final GradeCategoryEntity category;
  final List<ScoresEntity> scores;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAdd;
  final void Function(int scoreId) onDeleteScore;

  const ScoreSection({
    super.key,
    required this.category,
    required this.scores,
    required this.isExpanded,
    required this.onToggle,
    required this.onAdd,
    required this.onDeleteScore,
  });

  double get _average {
    if (scores.isEmpty) return 0;
    final total = scores.fold<double>(
      0, (sum, s) => sum + (s.maxScore > 0 ? s.scoreValue / s.maxScore : 0)
    );
    return (total / scores.length) * 100;
  }

  Color _averageColor(double avg) {
    if (avg >= 85) return AppColors.success;
    if (avg >= 70) return Color(0xFFF59E0B);
    return AppColors.destructive;
  }

  @override
  Widget build(BuildContext context) {
    final avg = _average;
    final hasScores = scores.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),

                      if (hasScores) ...[
                        const Gap(6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.foreground.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Text(
                            '${scores.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (hasScores) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _averageColor(avg).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${avg.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _averageColor(avg),
                      ),
                    ),
                  ),
                  const Gap(6),
                ],

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${category.weight.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandBlue,
                    ),
                  ),
                ),

                const Gap(6),

                GestureDetector(
                  onTap: onAdd,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.foreground,
                    ),
                  ),
                ),

                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedCrossFade(
          firstChild: scores.isEmpty
            ? _buildEmpty()
            : Column(
              children: scores
                .map((s) => ScoreTile(
                  score: s,
                  onDelete: () => onDeleteScore(s.id),
                ))
                .toList(),
            ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 220),
        ),

        const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 18,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),

          const Gap(8),

          Text(
            'No Scores Yet',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.foreground.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}