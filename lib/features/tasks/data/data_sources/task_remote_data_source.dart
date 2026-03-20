import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/tasks/data/models/task_model.dart';

class TaskRemoteDataSource {
  final SupabaseClient _client;

  const TaskRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  String? _trimTime(String? raw) =>
      raw != null && raw.length >= 5 ? raw.substring(0, 5) : raw;

  TaskModel _rowToModel(Map<String, dynamic> row) {
    final subject = row['subject'] as Map<String, dynamic>?;
    return TaskModel.fromMap({
      'id': row['id'],
      'title': row['title'],
      'due_date': row['due_date'],
      'due_time': _trimTime(row['due_time'] as String?),
      'status': row['status'] ?? 'pending',
      'sub_id': row['sub_id'],
      'subject_name': subject?['name'],
      'subject_code': subject?['code'],
    });
  }

  static const _taskSelect = '''
    id,
    sub_id,
    title,
    due_date,
    due_time,
    status,
    subject:sub_id (
      name,
      code
    )
  ''';

  Future<List<TaskModel>> getTasks() async {
    final data = await _client
        .from('tasks')
        .select(_taskSelect)
        .eq('user_id', _userId)
        .eq('is_deleted', false)
        .order('due_date', ascending: true, nullsFirst: false);

    return (data as List<dynamic>)
        .map((row) => _rowToModel(row as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> addTask(TaskModel task) async {
    final payload = <String, dynamic>{
      'user_id': _userId,
      'title': task.title,
      'status': task.status,
      if (task.subId != null) 'sub_id': task.subId,
      if (task.dueDate != null)
        'due_date': task.dueDate!.toIso8601String().substring(0, 10),
      if (task.dueTime != null) 'due_time': task.dueTime,
    };

    final data = await _client
        .from('tasks')
        .insert(payload)
        .select(_taskSelect)
        .single();

    return _rowToModel(data);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final payload = <String, dynamic>{
      'title': task.title,
      'status': task.status,
      'sub_id': task.subId,
      'due_date': task.dueDate?.toIso8601String().substring(0, 10),
      'due_time': task.dueTime,
    };

    final data = await _client
        .from('tasks')
        .update(payload)
        .eq('id', task.id)
        .eq('user_id', _userId)
        .select(_taskSelect)
        .single();

    return _rowToModel(data);
  }

  Future<void> deleteTask(int taskId) async {
    await _client
        .from('tasks')
        .update({'is_deleted': true})
        .eq('id', taskId)
        .eq('user_id', _userId);
  }
}
