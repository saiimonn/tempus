import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_scores.dart';

part 'scores_event.dart';
part 'scores_state.dart';

class ScoresBloc extends Bloc<ScoresEvent, ScoresState> {
  final AddScore _addScore;
  final DeleteScore _deleteScore;
  final GetScores _getScores;

  ScoresBloc({
    required GetScores getScores,
    required AddScore addScore,
    required DeleteScore deleteScore,
  }) : _getScores = getScores,
      _addScore = addScore,
      _deleteScore = deleteScore,
      super(ScoresInitial()) {
    on<ScoresLoadRequested>(_onLoad);
    on<ScoresCategoryToggled>(_onToggle);
    on<ScoresAddRequested>(_onAdd);
    on<ScoresDeleteRequested>(_onDelete);
  }

  Future <void> _onLoad(
    ScoresLoadRequested event,
    Emitter <ScoresState> emit,
  ) async {
    emit(ScoresLoading());
    try {
      final result = await _getScores(event.subjectId);
      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: {},
      ));
    } catch(_) {
      emit(ScoresError('Failed to load scores'));
    }
  }

  void _onToggle(
    ScoresCategoryToggled event,
    Emitter <ScoresState> emit,
  ) {
    if (state is! ScoresLoaded) return;

    final curr = state as ScoresLoaded;
    final expanded = Set<int>.from(curr.expandedCategories);
    if(expanded.contains(event.categoryId)) {
      expanded.remove(event.categoryId);
    } else {
      expanded.add(event.categoryId);
    }
    emit(curr.copyWith(expandedCategories: expanded));
  }

  Future <void> _onAdd(
    ScoresAddRequested event,
    Emitter <ScoresState> emit,
  ) async {
    if(state is! ScoresLoaded) return;

    final curr = state as ScoresLoaded;

    try {
      final newScore = await _addScore(
        categoryId: event.categoryId,
        title: event.title,
        scoreValue: event.scoreValue,
        maxScore: event.maxScore,
      );

      final updatedScores = Map<int, List<ScoresEntity>>.from(
        curr.scores.map((k, v) => MapEntry(k, List<ScoresEntity>.from(v))),
      );

      updatedScores[event.categoryId] = [
        ...?updatedScores[event.categoryId],
        newScore,
      ];

      final expanded = Set<int>.from(curr.expandedCategories)
        ..add(event.categoryId);
      emit(curr.copyWith(scores: updatedScores, expandedCategories: expanded));
    } catch(_) {
      emit(ScoresError('Failed to add score'));
    }
  }

  Future <void> _onDelete(
      ScoresDeleteRequested event,
      Emitter <ScoresState> emit,
    ) async {
      if (state is! ScoresLoaded) return;
      final curr = state as ScoresLoaded;

      try {
        await _deleteScore(categoryId: event.categoryId, scoreId: event.scoreId);

        final updatedScores = Map<int, List<ScoresEntity>>.from(
          curr.scores.map((k, v) => MapEntry(k, List<ScoresEntity>.from(v))),
        );

        updatedScores[event.categoryId] = (updatedScores[event.categoryId] ?? [])
          .where((s) => s.id != event.scoreId)
          .toList();
        emit(curr.copyWith(scores: updatedScores));
      } catch(_) {
        emit(ScoresError('Failed to delete score'));
      }
    }
}