import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class ScoresEvent {}

class LoadScores extends ScoresEvent {
  final int subjectId;
  LoadScores(this.subjectId);
}

class ToggleCategory extends ScoresEvent {
  final int categoryId;
  ToggleCategory(this.categoryId);
}

class AddScore extends ScoresEvent {
  final int categoryId;
  final String title;
  final double scoreValue;
  final double maxScore;

  AddScore({ 
    required this.categoryId,
    required this.title,
    required this.scoreValue,
    required this.maxScore,
  });
}

class DeleteScore extends ScoresEvent {
  final int categoryId;
  final int scoreId;

  DeleteScore({ required this.categoryId, required this.scoreId });
}

// STATES

abstract class ScoresState {}

class ScoresInitial extends ScoresState {}

class ScoresLoading extends ScoresState {}

class ScoresLoaded extends ScoresState {
  final Map<String, dynamic> subject;
  final List<Map<String, dynamic>> categories;
  final Map<int, List<Map<String, dynamic>>> scores;
  final Set<int> expandedCategories;

  ScoresLoaded({
    required this.subject,
    required this.categories,
    required this.scores,
    required this.expandedCategories,
  });

  ScoresLoaded copyWith({
    Map<String, dynamic>? subject,
    List<Map<String, dynamic>>? categories,
    Map<int, List<Map<String, dynamic>>>? scores,
    Set<int>? expandedCategories,
  }) {
    return ScoresLoaded(
      subject: subject ?? this.subject,
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

// BLOC

class ScoresBloc extends Bloc<ScoresEvent, ScoresState> {
  ScoresBloc(): super(ScoresInitial()) {
    on<LoadScores> (_onLoad);
    on<ToggleCategory> (_onToggle);
    on<AddScore> (_onAddScore);
    on<DeleteScore> (_onDeleteScore);
  }

  Future<void> _onLoad(
    LoadScores event,
    Emitter<ScoresState> emit,
  ) async {
    emit(ScoresLoading());
    await Future.delayed(const Duration(milliseconds: 400));

    final subject = {
      'id': event.subjectId,
      'name': 'Data Structures and Algorithms',
      'code': 'CS 2101',
    };

    // Mock categories 
    final categories = <Map<String, dynamic>>[
      {'id': 1, 'name': 'Quizzes', 'weight': 20.0},
      {'id': 2, 'name': 'Midterm Exam', 'weight': 30.0},
      {'id': 3, 'name': 'Final Project', 'weight': 50.0},
    ];

    // Mock scores 
    final scores = <int, List<Map<String, dynamic>>>{
      1: [
          {
            'id': 101,
            'title': 'Algebra Quiz',
            'score_value': 18.0,
            'max_score': 20.0,
          },
          {
            'id': 102,
            'title': 'Trigonometry Quiz',
            'score_value': 14.0,
            'max_score': 20.0,
          },
        ],
        2: [
          {
            'id': 201,
            'title': 'Midterm Examination',
            'score_value': 85.0,
            'max_score': 100.0,
          },
        ],
        3: [],
    };

    emit(ScoresLoaded(
      subject: subject,
      categories: categories,
      scores: scores,
      expandedCategories: {},
    ));
  }

  void _onToggle(
    ToggleCategory event,
    Emitter<ScoresState> emit,
  ) {
    if (state is! ScoresLoaded) return;

    final current = state as ScoresLoaded;
    final expanded = Set<int>.from(current.expandedCategories);

    if (expanded.contains(event.categoryId)) {
      expanded.remove(event.categoryId);
    } else {
      expanded.add(event.categoryId);
    }

    emit(current.copyWith(expandedCategories: expanded));
  }

  void _onAddScore(
    AddScore event,
    Emitter<ScoresState> emit,
  ) {
    if (state is! ScoresLoaded) return;

    final current = state as ScoresLoaded;

    final newScore = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': event.title,
      'score_value': event.scoreValue,
      'max_score': event.maxScore,
    };

    final updatedScores = Map<int, List<Map<String, dynamic>>>.from(
      current.scores.map((k, v) => MapEntry(k, List<Map<String, dynamic>>.from(v))),
    );

    updatedScores[event.categoryId] = [
      ...?updatedScores[event.categoryId],
      newScore,
    ];

    final expanded = Set<int>.from(current.expandedCategories)
      ..add(event.categoryId);

    emit(current.copyWith(scores: updatedScores, expandedCategories: expanded));
  }

  void _onDeleteScore(
    DeleteScore event,
    Emitter<ScoresState> emit,
  ) {
    if (state is! ScoresLoaded) return;
    final current = state as ScoresLoaded;

    final updatedScores = Map<int, List<Map<String, dynamic>>>.from(
      current.scores.map((k, v) => MapEntry(k, List<Map<String, dynamic>>.from(v))),
    );

    updatedScores[event.categoryId] = 
      (updatedScores[event.categoryId] ?? [])
        .where((s) => s['id'] != event.scoreId)
        .toList();

    emit(current.copyWith(scores: updatedScores));
  }
}