import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';

abstract class SubjectDetailRepository {
  Future <SubjectDetailEntity> getSubjectDetail(dynamic subjectId);
  Future <GradeCategoryEntity> addGradeCategory({
    required dynamic subjectId,
    required String name,
    required double weight,
  });

  Future<void> deleteGradeCategory({
    required dynamic subjectId,
    required int categoryId,
  });
}