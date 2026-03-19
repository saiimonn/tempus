import 'package:tempus/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.course,
    required super.yearLevel,
    required super.studentId,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? 'User',
      email: map['email'] as String? ?? '',
      course: map['course'] as String? ?? '',
      yearLevel: map['year_level'] as String? ?? '',
      studentId: (map['email'] as String? ?? '').replaceAll('@usc.edu.ph', ''),
    );
  }
}
