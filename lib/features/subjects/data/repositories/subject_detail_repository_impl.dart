import 'package:tempus/features/subjects/data/data_source/subject_detail_local_data_source.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class SubjectDetailRepositoryImpl implements SubjectDetailRepository {
  final SubjectDetailLocalDataSource dataSource;

  const SubjectDetailRepositoryImpl(this.dataSource);

  @override
  Future <SubjectDetailEntity> getSubjectDetail(dynamic subjectId) async {
    final subject = await dataSource.getSubject(subjectId);
    final categories = await dataSource.getCategories(subjectId);
    final estimatedGrade = await dataSource.getEstimatedGrade(subjectId);

    return SubjectDetailEntity(
      subject: subject,
      categories: categories,
      estimatedGrade: estimatedGrade,
    );
  }

  @override
  Future <GradeCategoryEntity> addGradeCategory({
    required dynamic subjectId,
    required String name,
    required double weight
  }) {
    return dataSource.addCategory(
      subjectId: subjectId,
      name: name,
      weight: weight,
    );
  }

  @override
  Future <void> deleteGradeCategory({
    required dynamic subjectId,
    required int categoryId,
  }) {
    return dataSource.deleteCategory(
      subjectId: subjectId,
      categoryId: categoryId,
    );
  }
}