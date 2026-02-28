import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/presentation/widgets/task_tile.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<TaskEntity> tasks;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool showAddButton;
  final VoidCallback? onAdd;

  const TaskSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.isExpanded,
    required this.onToggle,
    this.showAddButton = false,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),

                if (tasks.isNotEmpty) ...[
                  const Gap(6),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.foreground.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                if(showAddButton && onAdd != null)
                  GestureDetector(
                    onTap: () {
                      onAdd!();
                    },
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
          firstChild: tasks.isEmpty
            ? _buildEmpty()
            : Column(
              children: tasks
                .map((task) => TaskTile(task: task))
                .toList(),
            ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded 
            ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
            'No entries found',
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