import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';

class SubjectDetailEntity {
  final SubjectEntity subject;
  final List<GradeCategoryEntity> categories;
  final double estimatedGrade;

  const SubjectDetailEntity({
    required this.subject,
    required this.categories,
    required this.estimatedGrade,
  });

  double get totalWeight =>
    categories.fold(0.0, (sum, c) => sum + c.weight);
}