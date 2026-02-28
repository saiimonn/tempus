import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class DeleteGradeCategory {
  final SubjectDetailRepository repo;

  const DeleteGradeCategory(this.repo);

  Future <void> call({
    required dynamic subjectId,
    required int categoryId,
  }) => repo.deleteGradeCategory(
    subjectId: subjectId,
    categoryId: categoryId,
  );
}