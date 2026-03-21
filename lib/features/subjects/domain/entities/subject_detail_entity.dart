import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';

class SubjectDetailEntity {
  final SubjectEntity subject;
  final List<GradeCategoryEntity> categories;
  final Map<int, List<ScoresEntity>> scores;

  const SubjectDetailEntity({
    required this.subject,
    required this.categories,
    this.scores = const {},
  });

  double get totalWeight => categories.fold(0.0, (sum, c) => sum + c.weight);

  // (0 - 100)
  double get estimatedGrade {
    double weightedSum = 0.0;
    double activeWeight = 0.0;

    for (final category in categories) {
      final catScores = scores[category.id] ?? [];
      if (catScores.isEmpty) continue;

      final totalScoreValue = catScores.fold<double>(
        0.0,
        (s, e) => s + e.scoreValue,
      );

      final totalMaxScore = catScores.fold<double>(
        0.0,
        (s, e) => s + e.maxScore,
      );

      if (totalMaxScore <= 0) continue;

      final categoryPercent = (totalScoreValue / totalMaxScore) * 100;
      weightedSum += categoryPercent * category.weight;
      activeWeight += category.weight;
    }

    if (activeWeight <= 0) return 0.0;

    return weightedSum / activeWeight;
  }
}
