import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.code,
    required super.instructor,
    required super.units,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] is String ? int.parse(map['id'] as String) : map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      instructor: map['instructor'] as String? ?? '',
      units: map['units'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'instructor': instructor,
      'units': units,
    };
  }
}