class TaskEntity {
  final int id;
  final String title;
  final DateTime? dueDate;
  final String? dueTime;
  final String status;
  final int? subId;
  final String? subjectName;
  final String? subjectCode;

  const TaskEntity({
    required this.id,
    required this.title,
    this.dueDate,
    this.dueTime,
    this.status = 'pending',
    this.subId,
    this.subjectName,
    this.subjectCode,
  });

  bool get isComplete => status == 'completed';

  bool get isToday {
    if (dueDate == null) return false;

    final now = DateTime.now();

    return dueDate!.year == now.year && 
      dueDate!.month == now.month &&
      dueDate!.day == now.day;
  }

  bool get isUpcoming {
    if (dueDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return taskDay.isAfter(today);
  }

  bool get hasNoDue => dueDate == null;

  TaskEntity copyWith({
    int? id,
    String? title,
    DateTime? dueDate,
    String? dueTime,
    String? status,
    int? subId,
    String? subjectName,
    String? subjectCode,
    bool clearDueDate = false,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      dueTime: dueTime ?? this.dueTime,
      status: status ?? this.status,
      subId: subId ?? this.subId,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
    );
  }
}