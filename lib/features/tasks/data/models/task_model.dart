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
    return TaskModel(
      id: map['id'] as int,
      title: map['title'] as String,
      dueDate: map['due_date'] != null
        ? DateTime.parse(map['due_date'] as String)
        : null,
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