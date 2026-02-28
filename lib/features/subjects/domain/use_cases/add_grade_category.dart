import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class AddGradeCategory {
  final SubjectDetailRepository repo;

  const AddGradeCategory(this.repo);

  Future <GradeCategoryEntity> call({
    required dynamic subjectId,
    required String name,
    required double weight,
  }) => repo.addGradeCategory(
    subjectId: subjectId,
    name: name,
    weight: weight,
  );
}