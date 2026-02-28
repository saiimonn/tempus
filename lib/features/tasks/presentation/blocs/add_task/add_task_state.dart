part of 'add_task_bloc.dart';

class SelectedSubject {
  final int id;
  final String name;
  final String code;
  const SelectedSubject({
    required this.id,
    required this.name,
    required this.code,
  });
}

class AddTaskState {
  final DateTime? dueDate;
  final String? dueTime;
  final SelectedSubject? selectedSubject;

  const AddTaskState({
    this.dueDate,
    this.dueTime,
    this.selectedSubject,
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
    SelectedSubject? selectedSubject,
    bool clearDueDate = false,
    bool clearDueTime = false,
    bool clearSubject = false,
  }) {
    return AddTaskState(
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      dueTime: clearDueTime ? null : (dueTime ?? this.dueTime),
      selectedSubject:
          clearSubject ? null : (selectedSubject ?? this.selectedSubject),
    );
  }
}