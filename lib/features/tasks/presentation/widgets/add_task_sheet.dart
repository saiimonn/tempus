import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/custom_text_field.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/presentation/blocs/add_task/add_task_bloc.dart';
import 'package:tempus/features/tasks/presentation/blocs/task/task_bloc.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, AddTaskState formState) {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final task = TaskEntity(
      id: 0, // will be replaced by data source
      title: title,
      dueDate: formState.dueDate,
      dueTime: formState.dueTime,
      status: 'pending',
    );

    context.read<TaskBloc>().add(TaskAddRequested(task));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider(
      create: (_) => AddTaskBloc(),
      child: BlocBuilder<AddTaskBloc, AddTaskState>(
        builder: (context, formState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                CustomTextField(
                  label: 'Task',
                  controller: _titleController,
                  hint: 'e.g. Submit Data Structure',
                  autofocus: true,
                  onFieldSubmitted: (_) => _submit(context, formState),
                ),
                const Gap(8),
                // Action row
                Row(
                  children: [
                    // Date picker
                    _DateChip(
                      label: formState.dueDate != null
                          ? formState.dueDateLabel
                          : 'Date',
                      isActive: formState.dueDate != null,
                      onTap: () => _showDateOptions(context),
                    ),
                    const Gap(8),
                    if (formState.dueDate != null)
                      _TimeChip(
                        label: formState.dueTime != null
                            ? _formatTime(formState.dueTime!)
                            : 'Time',
                        isActive: formState.dueTime != null,
                        onTap: () => _showTimePicker(context),
                      ),
                    const Spacer(),
                    ListenableBuilder(
                      listenable: _titleController,
                      builder: (context, _) {
                        final hasText = _titleController.text.trim().isNotEmpty;
                        return GestureDetector(
                          onTap: hasText ? () => _submit(context, formState) : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasText
                                  ? AppColors.brandBlue
                                  : AppColors.inputFill,
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              size: 18,
                              color: hasText ? Colors.white : AppColors.foreground,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final period = h >= 12 ? 'PM' : 'AM';
    final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$displayH:$m $period';
  }

  void _showDateOptions(BuildContext context) {
    final bloc = context.read<AddTaskBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const _DateOptionsSheet(),
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final bloc = context.read<AddTaskBloc>();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.brandBlue,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;
    final h = picked.hour.toString().padLeft(2, '0');
    final m = picked.minute.toString().padLeft(2, '0');
    bloc.add(AddTaskDueTimeChanged('$h:$m'));
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.brandBlue.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.brandBlue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 13,
              color: isActive ? AppColors.brandBlue : AppColors.foreground,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.brandBlue : AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.brandBlue.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.brandBlue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 13,
              color: isActive ? AppColors.brandBlue : AppColors.foreground,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.brandBlue : AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateOptionsSheet extends StatelessWidget {
  const _DateOptionsSheet();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final thisWeekend = _nextWeekend(today);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 22, color: AppColors.text),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AddTaskBloc>().add(AddTaskDueDateCleared());
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.check, size: 22, color: AppColors.brandBlue),
              ),
            ],
          ),
          const Gap(16),
          _DateOption(
            icon: Icons.today_rounded,
            label: 'Today',
            color: AppColors.success,
            onTap: () {
              context.read<AddTaskBloc>().add(AddTaskDueDateChanged(today));
              Navigator.of(context).pop();
            },
          ),
          _DateOption(
            icon: Icons.wb_sunny_rounded,
            label: 'Tomorrow',
            color: AppColors.brandBlue,
            onTap: () {
              context.read<AddTaskBloc>().add(AddTaskDueDateChanged(tomorrow));
              Navigator.of(context).pop();
            },
          ),
          _DateOption(
            icon: Icons.weekend_rounded,
            label: 'This Weekend',
            color: const Color(0xFFF59E0B),
            onTap: () {
              context.read<AddTaskBloc>().add(AddTaskDueDateChanged(thisWeekend));
              Navigator.of(context).pop();
            },
          ),
          _DateOption(
            icon: Icons.event_rounded,
            label: 'Next Week',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              context.read<AddTaskBloc>().add(
                    AddTaskDueDateChanged(today.add(const Duration(days: 7))));
              Navigator.of(context).pop();
            },
          ),
          _DateOption(
            icon: Icons.calendar_month_rounded,
            label: 'No Date',
            color: AppColors.foreground,
            onTap: () {
              context.read<AddTaskBloc>().add(AddTaskDueDateCleared());
              Navigator.of(context).pop();
            },
          ),
          const Gap(8),
          // Custom date picker
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: today,
                firstDate: today,
                lastDate: today.add(const Duration(days: 365)),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.brandBlue,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null && context.mounted) {
                context.read<AddTaskBloc>().add(AddTaskDueDateChanged(picked));
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.edit_calendar_rounded, size: 16),
            label: const Text('Enter Date'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.foreground,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _nextWeekend(DateTime from) {
    int daysUntilSat = (6 - from.weekday) % 7;
    if (daysUntilSat == 0) daysUntilSat = 7;
    return from.add(Duration(days: daysUntilSat));
  }
}

class _DateOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DateOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}