import 'package:tempus/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    super.dueDate,
    super.dueTime,
    required super.status,
    super.subId,
    super.subjectName,
    super.subjectCode,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    // Supabase returns DATE as "YYYY-MM-DD". DateTime.parse produces UTC
    // midnight which can shift the calendar day for users in UTC+ zones.
    // .toLocal() ensures isToday / isUpcoming comparisons are always correct.
    DateTime? parsedDate;
    if (map['due_date'] != null) {
      parsedDate = DateTime.parse(map['due_date'] as String).toLocal();
    }

    return TaskModel(
      id: map['id'] as int,
      title: map['title'] as String,
      dueDate: parsedDate,
      dueTime: map['due_time'] as String?,
      status: map['status'] as String? ?? 'pending',
      subId: map['sub_id'] as int?,
      subjectName: map['subject_name'] as String?,
      subjectCode: map['subject_code'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'due_date': dueDate,
      'due_time': dueTime,
      'status': status,
      'sub_id': subId,
      'subject_name': subjectName,
      'subject_code': subjectCode,
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      dueDate: entity.dueDate,
      dueTime: entity.dueTime,
      status: entity.status,
      subId: entity.subId,
      subjectName: entity.subjectName,
      subjectCode: entity.subjectCode,
    );
  }
}