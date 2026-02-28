import 'package:tempus/features/tasks/data/models/task_model.dart';

class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final sunday = today.add(const Duration(days: 3));

    // MOCK DATA
    return [
      TaskModel.fromMap({
        'id': 1,
        'title': 'Submit Data Structure',
        'due_date': today.toIso8601String(),
        'due_time': '11:00',
        'status': 'pending',
        'sub_id': 1,
        'subject_name': 'Data Structures and Algorithms',
        'subject_code': 'DSA',
      }),
      TaskModel.fromMap({
        'id': 2,
        'title': 'Submit Data Structure',
        'due_date': today.toIso8601String(),
        'due_time': '13:00',
        'status': 'pending',
        'sub_id': 1,
        'subject_name': 'Data Structures and Algorithms',
        'subject_code': 'DSA',
      }),
      TaskModel.fromMap({
        'id': 3,
        'title': 'Submit Data Structure',
        'due_date': tomorrow.toIso8601String(),
        'due_time': '09:00',
        'status': 'pending',
        'sub_id': 2,
        'subject_name': 'Object Oriented Programming',
        'subject_code': 'OOP',
      }),
      TaskModel.fromMap({
        'id': 4,
        'title': 'Submit Data Structure',
        'due_date': sunday.toIso8601String(),
        'due_time': '08:00',
        'status': 'pending',
        'sub_id': 3,
        'subject_name': 'Discrete Mathematics',
        'subject_code': 'DISMAT',
      }),
      TaskModel.fromMap({
        'id': 5,
        'title': 'Submit Data Structure',
        'due_date': null,
        'due_time': null,
        'status': 'pending',
        'sub_id': null,
        'subject_name': null,
        'subject_code': null,
      }),
      TaskModel.fromMap({
        'id': 6,
        'title': 'Submit Data Structure',
        'due_date': today.subtract(const Duration(days: 3)).toIso8601String(),
        'due_time': '10:00',
        'status': 'completed',
        'sub_id': 1,
        'subject_name': 'Data Structures and Algorithms',
        'subject_code': 'DSA',
      }),
    ];
  }

  Future <TaskModel> addTask(TaskModel task) async {
    return TaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: task.title,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
      status: task.status,
      subId: task.subId,
      subjectName: task.subjectName,
      subjectCode: task.subjectCode,
    );
  }

  Future <TaskModel> updateTask(TaskModel task) async {
    return task;
  }

  Future <void> deleteTask(int taskId) async {
    
  }
}