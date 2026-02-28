import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.code,
    required super.instructor,
    required super.units,
    required super.grades,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'].toString(),
      name: map['name'] as String,
      code: map['code'] as String,
      instructor: map['instructor'] as String? ?? '',
      units: map['units'] as int,
      grades: Map<String, String>.from(
        map['grades'] as Map? ?? {'prelim': '--', 'midterm' : '--', 'final' : '--'}
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'code' : name,
      'instructor' : instructor,
      'units' : units,
      'grades' : grades,
    };
  }
}