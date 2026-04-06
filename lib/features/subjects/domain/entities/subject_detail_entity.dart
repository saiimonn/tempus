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
  double get _weightedPercent {
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

  double get estimatedGrade {
    final pct = _weightedPercent;
    if (pct < 0) return 0.0;
    return percentToPhGrade(pct);
  }

  double get estimatedPercent {
    final pct = _weightedPercent;
    return pct < 0 ? 0.0 : pct;
  }

  static double percentToPhGrade(double pct) {
    if (pct >= 97) return 1.00;
    if (pct >= 94) return 1.25;
    if (pct >= 91) return 1.50;
    if (pct >= 88) return 1.75;
    if (pct >= 85) return 2.00;
    if (pct >= 82) return 2.25;
    if (pct >= 79) return 2.50;
    if (pct >= 76) return 2.75;
    if (pct >= 75) return 3.00;
    return 5.00;
  }
}
