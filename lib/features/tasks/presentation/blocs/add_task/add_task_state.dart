part of 'add_task_bloc.dart';

class AddTaskState {
  final DateTime? dueDate;
  final String? dueTime; // "HH:mm"

  const AddTaskState({
    this.dueDate,
    this.dueTime,
  });

  String get dueDateLabel {
    if (dueDate == null) return 'No Date';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    if (taskDay == today) return 'Today';
    if (taskDay == tomorrow) return 'Tomorrow';

    final diff = taskDay.difference(today).inDays;
    if (diff <= 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dueDate!.weekday - 1];
    }

    return '${dueDate!.month}/${dueDate!.day}';
  }

  AddTaskState copyWith({
    DateTime? dueDate,
    String? dueTime,
    bool clearDueDate = false,
    bool clearDueTime = false,
  }) {
    return AddTaskState(
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      dueTime: clearDueTime ? null : (dueTime ?? this.dueTime),
    );
  }
}