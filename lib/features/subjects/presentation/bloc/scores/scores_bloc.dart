import 'package:equatable/equatable.dart';
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

  // Stored so we can re-fetch after mutations.
  int? _subjectId;

  ScoresBloc({
    required GetScores getScores,
    required AddScore addScore,
    required DeleteScore deleteScore,
  })  : _getScores = getScores,
        _addScore = addScore,
        _deleteScore = deleteScore,
        super(ScoresInitial()) {
    on<ScoresLoadRequested>(_onLoad);
    on<ScoresCategoryToggled>(_onToggle);
    on<ScoresAddRequested>(_onAdd);
    on<ScoresDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    ScoresLoadRequested event,
    Emitter<ScoresState> emit,
  ) async {
    _subjectId = event.subjectId;
    emit(ScoresLoading());
    try {
      final result = await _getScores(event.subjectId);
      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: {},
      ));
    } catch (e) {
      emit(ScoresError('Failed to load scores'));
    }
  }

  void _onToggle(
    ScoresCategoryToggled event,
    Emitter<ScoresState> emit,
  ) {
    if (state is! ScoresLoaded) return;
    final curr = state as ScoresLoaded;
    final expanded = Set<int>.from(curr.expandedCategories);
    if (expanded.contains(event.categoryId)) {
      expanded.remove(event.categoryId);
    } else {
      expanded.add(event.categoryId);
    }
    emit(curr.copyWith(expandedCategories: expanded));
  }

  Future<void> _onAdd(
    ScoresAddRequested event,
    Emitter<ScoresState> emit,
  ) async {
    if (state is! ScoresLoaded) return;
    final curr = state as ScoresLoaded;

    // Keep track of which categories were expanded so the UI doesn't collapse.
    final expandedBefore = Set<int>.from(curr.expandedCategories)
      ..add(event.categoryId);

    try {
      await _addScore(
        categoryId: event.categoryId,
        title: event.title,
        scoreValue: event.scoreValue,
        maxScore: event.maxScore,
      );

      // Re-fetch from remote — same pattern as SubjectDetailBloc.
      // This avoids fragile optimistic state surgery and guarantees the
      // emitted state matches what's actually in the DB.
      if (_subjectId == null) return;
      final result = await _getScores(_subjectId!);

      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: expandedBefore,
      ));
    } catch (e) {
      // Restore previous state rather than showing an error — the insert
      // may have succeeded even if the subsequent fetch had a transient
      // issue. Keeping curr visible is less disruptive than a blank error.
      emit(curr.copyWith(expandedCategories: expandedBefore));
    }
  }

  Future<void> _onDelete(
    ScoresDeleteRequested event,
    Emitter<ScoresState> emit,
  ) async {
    if (state is! ScoresLoaded) return;
    final curr = state as ScoresLoaded;

    try {
      await _deleteScore(
        categoryId: event.categoryId,
        scoreId: event.scoreId,
      );

      // Re-fetch for consistency — mirrors _onAdd approach.
      if (_subjectId == null) return;
      final result = await _getScores(_subjectId!);

      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: curr.expandedCategories,
      ));
    } catch (e) {
      emit(ScoresError('Failed to delete score'));
    }
  }
}