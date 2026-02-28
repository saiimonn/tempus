import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';

class ScheduleSubjectModel extends ScheduleSubjectEntity {
  const ScheduleSubjectModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory ScheduleSubjectModel.fromMap(Map<String, dynamic> map) {
    return ScheduleSubjectModel(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}