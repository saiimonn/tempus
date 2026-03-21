class SubjectEntity {
  final int id;
  final String name;
  final String code;
  final String instructor;
  final int units;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.instructor,
    required this.units,
  });

  SubjectEntity copyWith({
    int? id,
    String? name,
    String? code,
    String? instructor,
    int? units,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      instructor: instructor ?? this.instructor,
      units: units ?? this.units,
    );
  }
}