part of 'scores_bloc.dart';

sealed class ScoresState extends Equatable {
  const ScoresState();

  @override
  List<Object?> get props => [];
}

class ScoresInitial extends ScoresState {}

class ScoresLoading extends ScoresState {}

class ScoresLoaded extends ScoresState {
  final List<GradeCategoryEntity> categories;
  final Map<int, List<ScoresEntity>> scores;
  final Set<int> expandedCategories;

  const ScoresLoaded({
    required this.categories,
    required this.scores,
    required this.expandedCategories,
  });

  @override
  List<Object?> get props => [categories, scores, expandedCategories];

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
  const ScoresError(this.message);

  @override
  List<Object?> get props => [message];
}
