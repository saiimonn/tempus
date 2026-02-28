part of 'scores_bloc.dart';

sealed class ScoresEvent {}

class ScoresLoadRequested extends ScoresEvent {
  final int subjectId;
  ScoresLoadRequested(this.subjectId);
}

class ScoresCategoryToggled extends ScoresEvent {
  final int categoryId;
  ScoresCategoryToggled(this.categoryId);
}

class ScoresAddRequested extends ScoresEvent {
  final int categoryId;
  final String title;
  final double scoreValue;
  final double maxScore;

  ScoresAddRequested({
    required this.categoryId,
    required this.title,
    required this.scoreValue,
    required this.maxScore,
  });
}

class ScoresDeleteRequested extends ScoresEvent {
  final int categoryId;
  final int scoreId;

  ScoresDeleteRequested({
    required this.categoryId,
    required this.scoreId,
  });
}