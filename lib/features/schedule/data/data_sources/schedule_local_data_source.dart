import 'package:tempus/features/schedule/data/models/schedule_entry_model.dart';
import 'package:tempus/features/schedule/data/models/schedule_subject_model.dart';

class ScheduleLocalDataSource {
  Future <List<ScheduleSubjectModel>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // FAKE DATA
    return [
      ScheduleSubjectModel.fromMap({'id': 1, 'name': 'Mathematics', 'code': 'MATH101'}),
      ScheduleSubjectModel.fromMap({'id': 2, 'name': 'Physics', 'code': 'PHYS202'}),
      ScheduleSubjectModel.fromMap({
        'id': 3,
        'name': 'Data Structures and Algorithms',
        'code': 'CS2101',
      }),
    ];
  }

  Future <List<ScheduleEntryModel>> getEntries() async {
    return [
      ScheduleEntryModel.fromMap({
        'id': 1,
        'sub_id': 1,
        'subject_name': 'Data Structures and Algorithms',
        'subject_code': 'DSA',
        'days': ['Monday', 'Wednesday', 'Friday'],
        'start_time': '07:30',
        'end_time': '10:00',
      }),
      ScheduleEntryModel.fromMap({
        'id': 2,
        'sub_id': 2,
        'subject_name': 'Object Oriented Programming',
        'subject_code': 'OOP',
        'days': ['Monday', 'Tuesday', 'Thursday'],
        'start_time': '10:00',
        'end_time': '12:30',
      }),
      ScheduleEntryModel.fromMap({
        'id': 3,
        'sub_id': 3,
        'subject_name': 'Technical and Professional English',
        'subject_code': 'TPE',
        'days': ['Monday', 'Wednesday'],
        'start_time': '13:00',
        'end_time': '14:00',
      }),
      ScheduleEntryModel.fromMap({
        'id': 4,
        'sub_id': 1,
        'subject_name': 'Data Structures and Algorithms Practicum',
        'subject_code': 'DATAP',
        'days': ['Monday', 'Friday'],
        'start_time': '15:00',
        'end_time': '16:30',
      }),
    ];
  }

  Future <ScheduleEntryModel> addEntry({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) async {
    return ScheduleEntryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      subId: subId,
      subjectName: subjectName,
      subjectCode: subjectCode,
      days: days,
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future <void> deleteEntry(int entryId) async {
    //
  }
}