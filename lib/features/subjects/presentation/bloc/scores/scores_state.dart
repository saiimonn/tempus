part of 'scores_bloc.dart';

sealed class ScoresState {}

class ScoresInitial extends ScoresState {}

class ScoresLoading extends ScoresState {}

class ScoresLoaded extends ScoresState {
  final List<GradeCategoryEntity> categories;
  final Map<int, List<ScoresEntity>> scores;
  final Set<int> expandedCategories;

  ScoresLoaded({
    required this.categories,
    required this.scores,
    required this.expandedCategories,
  });

  ScoresLoaded copyWith({
    List<GradeCategoryEntity>? categories,
    Map<int, List<ScoresEntity>>? scores,
    Set<int>? expandedCategories,
  }) {
    return ScoresLoaded(
      categories: categories ?? this.categories,
      scores: scores ?? this.scores,
      expandedCategories: expandedCategories ?? this.expandedCategories,
    );
  }
}

class ScoresError extends ScoresState {
  final String message;
  ScoresError(this.message);
}