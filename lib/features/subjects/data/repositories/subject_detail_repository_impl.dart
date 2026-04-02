import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/data_source/scores_remote_data_source.dart';
import 'package:tempus/features/subjects/data/data_source/subject_detail_remote_data_source.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class SubjectDetailRepositoryImpl implements SubjectDetailRepository {
  final SubjectDetailRemoteDataSource dataSource;
  final ScoresRemoteDataSource scoresDataSource;

  const SubjectDetailRepositoryImpl(this.dataSource, this.scoresDataSource);

  factory SubjectDetailRepositoryImpl.create() {
    final client = Supabase.instance.client;
    return SubjectDetailRepositoryImpl(
      SubjectDetailRemoteDataSource(client),
      ScoresRemoteDataSource(client),
    );
  }

  @override
  Future<SubjectDetailEntity> getSubjectDetail(dynamic subjectId) async {
    final subject = await dataSource.getSubject(subjectId);
    final categories = await dataSource.getCategories(subjectId);
    final scores = await scoresDataSource.getScores(subjectId);

    return SubjectDetailEntity(
      subject: subject,
      categories: categories,
      scores: scores,
    );
  }

  @override
  Future<GradeCategoryEntity> addGradeCategory({
    required dynamic subjectId,
    required String name,
    required double weight,
  }) {
    return dataSource.addCategory(
      subjectId: subjectId,
      name: name,
      weight: weight,
    );
  }

  @override
  Future<GradeCategoryEntity> updateGradeCategory({
    required int categoryId,
    required String name,
    required double weight,
  }) {
    return dataSource.updateCategory(
      categoryId: categoryId,
      name: name,
      weight: weight,
    );
  }

  @override
  Future<void> deleteGradeCategory({
    required dynamic subjectId,
    required int categoryId,
  }) {
    return dataSource.deleteCategory(
      subjectId: subjectId,
      categoryId: categoryId,
    );
  }
}
