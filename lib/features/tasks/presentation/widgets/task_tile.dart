import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/presentation/blocs/task/task_bloc.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;

  const TaskTile({super.key, required this.task});

  String get _subtitleText {
    final parts = <String>[];

    if (task.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final taskDay = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      final diff = taskDay.difference(today).inDays;

      if (diff == 0) {
        parts.add('Today');
      } else if (diff == 1) {
        parts.add('Tomorrow');
      } else if (diff == -1) {
        parts.add('Yesterday');
      } else if (diff < 0) {
        parts.add('${diff.abs()} days ago');
      } else {
        // Format date nicely
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        parts.add('${months[task.dueDate!.month - 1]} ${task.dueDate!.day}');
      }
    }

    if (task.dueTime != null) {
      final timeParts = task.dueTime!.split(':');
      final h = int.parse(timeParts[0]);
      final m = timeParts[1];
      final period = h >= 12 ? 'PM' : 'AM';
      final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      parts.add('$displayH:$m $period');
    }

    if (task.subjectCode != null) {
      parts.add(task.subjectCode!);
    }

    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('task_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22)
      ),
      onDismissed: (_) => 
        context.read<TaskBloc>().add(TaskDeleteRequested(task.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.read<TaskBloc>().add(TaskToggleCompleted(task.id)),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isComplete
                      ? AppColors.success
                      : AppColors.foreground.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  color: task.isComplete
                    ? AppColors.success
                    : Colors.transparent,
                ),
                child: task.isComplete
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
              ),
            ),

            const Gap(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: task.isComplete
                        ? AppColors.foreground
                        : AppColors.text,
                      decoration: task.isComplete
                        ? TextDecoration.lineThrough
                        : null,
                      decorationColor: AppColors.foreground,
                    ),
                  ),

                  if (_subtitleText.isNotEmpty)
                    Text(
                      _subtitleText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.foreground,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}