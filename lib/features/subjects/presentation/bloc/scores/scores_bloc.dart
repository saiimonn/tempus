import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_scores.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_score.dart';

part 'scores_event.dart';
part 'scores_state.dart';

class ScoresBloc extends Bloc<ScoresEvent, ScoresState> {
  final AddScore _addScore;
  final UpdateScore _updateScore;
  final DeleteScore _deleteScore;
  final GetScores _getScores;

  int? _subjectId;

  ScoresBloc({
    required GetScores getScores,
    required AddScore addScore,
    required UpdateScore updateScore,
    required DeleteScore deleteScore,
  })  : _getScores = getScores,
        _addScore = addScore,
        _updateScore = updateScore,
        _deleteScore = deleteScore,
        super(ScoresInitial()) {
    on<ScoresLoadRequested>(_onLoad);
    on<ScoresCategoryToggled>(_onToggle);
    on<ScoresAddRequested>(_onAdd);
    on<ScoresUpdateRequested>(_onUpdate);
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

    final expandedBefore = Set<int>.from(curr.expandedCategories)
      ..add(event.categoryId);

    try {
      await _addScore(
        categoryId: event.categoryId,
        title: event.title,
        scoreValue: event.scoreValue,
        maxScore: event.maxScore,
      );

      if (_subjectId == null) return;
      final result = await _getScores(_subjectId!);

      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: expandedBefore,
      ));
    } catch (e) {
      emit(curr.copyWith(expandedCategories: expandedBefore));
    }
  }

  Future<void> _onUpdate(
    ScoresUpdateRequested event,
    Emitter<ScoresState> emit,
  ) async {
    if (state is! ScoresLoaded) return;
    final curr = state as ScoresLoaded;

    // Optimistic update
    final optimisticScores = curr.scores.map((catId, scoreList) {
      return MapEntry(
        catId,
        scoreList.map((s) {
          if (s.id != event.scoreId) return s;
          return ScoresEntity(
            id: s.id,
            title: event.title,
            scoreValue: event.scoreValue,
            maxScore: event.maxScore,
          );
        }).toList(),
      );
    });
    
    emit(curr.copyWith(scores: optimisticScores));

    try {
      await _updateScore(
        scoreId: event.scoreId,
        categoryId: event.categoryId,
        title: event.title,
        scoreValue: event.scoreValue,
        maxScore: event.maxScore,
      );

      if (_subjectId == null) return;
      final result = await _getScores(_subjectId!);

      emit(ScoresLoaded(
        categories: result.categories,
        scores: result.scores,
        expandedCategories: curr.expandedCategories,
      ));
    } catch (e) {
      emit(curr);
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