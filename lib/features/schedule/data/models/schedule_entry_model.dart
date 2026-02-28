import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';

class ScheduleEntryModel extends ScheduleEntryEntity {
  const ScheduleEntryModel({
    required super.id,
    required super.subId,
    required super.subjectName,
    required super.subjectCode,
    required super.days,
    required super.startTime,
    required super.endTime,
  });

  factory ScheduleEntryModel.fromMap(Map<String, dynamic> map) {
    return ScheduleEntryModel(
      id: map['id'] as int,
      subId: map['sub_id'] as int,
      subjectName: map['subject_name'] as String,
      subjectCode: map['subject_code'] as String,
      days: List<String>.from(map['days'] as List),
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sub_id': subId,
      'subject_name': subjectName,
      'subject_code': subjectCode,
      'days': days,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}