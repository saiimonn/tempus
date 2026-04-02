import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class UpdateGradeCategory {
  final SubjectDetailRepository repo;

  const UpdateGradeCategory(this.repo);

  Future<GradeCategoryEntity> call({
    required int categoryId,
    required String name,
    required double weight,
  }) => repo.updateGradeCategory(
    categoryId: categoryId,
    name: name,
    weight: weight,
  );
}
