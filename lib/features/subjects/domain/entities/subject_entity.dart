class SubjectEntity {
  final String id;
  final String name;
  final String code;
  final String instructor;
  final int units;
  final Map<String, String> grades;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.instructor,
    required this.units,
    required this.grades,
  });
}