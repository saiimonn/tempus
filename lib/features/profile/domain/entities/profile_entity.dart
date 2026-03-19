class ProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String course;
  final String yearLevel;
  final String studentId;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.course,
    required this.yearLevel,
    required this.studentId,
  });

  String get firstName => fullName.split(' ').first;

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  ProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? course,
    String? yearLevel,
    String? studentId,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      course: course ?? this.course,
      yearLevel: yearLevel ?? this.yearLevel,
      studentId: studentId ?? this.studentId,
    );
  }
}
