import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class SubjectDetailEvent {}

class LoadSubjectDetail extends SubjectDetailEvent {
  final dynamic subjectId;
  LoadSubjectDetail(this.subjectId);
}

class AddGradeCategory extends SubjectDetailEvent {
  final String name;
  final double weight;
  AddGradeCategory({required this.name, required this.weight});
}

class DeleteGradeCategory extends SubjectDetailEvent {
  final int categoryId;
  DeleteGradeCategory(this.categoryId);
}

// STATES
abstract class SubjectDetailState {}

class SubjectDetailInitial extends SubjectDetailState {}

class SubjectDetailLoading extends SubjectDetailState {}

class SubjectDetailLoaded extends SubjectDetailState {
  final Map<String, dynamic> subject;
  final List<Map<String, dynamic>> categories;
  final double estimatedGrade;
  final double totalWeight;

  SubjectDetailLoaded({
    required this.subject,
    required this.categories,
    required this.estimatedGrade,
    required this.totalWeight,
  });

  SubjectDetailLoaded copyWith({
    Map<String, dynamic>? subject,
    List<Map<String, dynamic>>? categories,
    double? estimatedGrade,
    double? totalWeight,
  }) {
    return SubjectDetailLoaded(
      subject: subject ?? this.subject,
      categories: categories ?? this.categories,
      estimatedGrade: estimatedGrade ?? this.estimatedGrade,
      totalWeight: totalWeight ?? this.totalWeight,
    );
  }
}

class SubjectDetailError extends SubjectDetailState {
  final String message;
  SubjectDetailError(this.message);
}

// BLOC

class SubjectDetailBloc extends Bloc<SubjectDetailEvent, SubjectDetailState> {
  SubjectDetailBloc() : super(SubjectDetailInitial()) {
    on<LoadSubjectDetail>(_onLoad);
    on<AddGradeCategory>(_onAddCategory);
    on<DeleteGradeCategory>(_onDeleteCategory);
  }

  Future<void> _onLoad(
    LoadSubjectDetail event,
    Emitter<SubjectDetailState> emit,
  ) async {
    emit(SubjectDetailLoading());
    await Future.delayed(const Duration(milliseconds: 400));

    final subject = {
      'id': event.subjectId,
      'name': 'Data Structures and Algorithms',
      'code': 'CS 2101',
      'prof': 'Dr. Cruz',
      'units': 3,
    };

    final categories = <Map<String, dynamic>>[
      {'id': 1, 'name': 'Quizzes', 'weight': 20.0},
      {'id': 2, 'name': 'Midterm Exam', 'weight': 30.0},
      {'id': 3, 'name': 'Final Project', 'weight': 50.0},
    ];

    emit(
      SubjectDetailLoaded(
        subject: subject,
        categories: categories,
        estimatedGrade: 1.8,
        totalWeight: _computeTotalWeight(categories),
      ),
    );
  }

  Future<void> _onAddCategory(
    AddGradeCategory event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (state is! SubjectDetailLoaded) return;

    final current = state as SubjectDetailLoaded;

    final newCategory = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': event.name,
      'weight': event.weight,
    };

    final updated = List<Map<String, dynamic>>.from(current.categories)
      ..add(newCategory);

    emit(
      current.copyWith(
        categories: updated,
        totalWeight: _computeTotalWeight(updated),
      ),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteGradeCategory event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (state is! SubjectDetailLoaded) return;

    final current = state as SubjectDetailLoaded;

    final updated = current.categories
        .where((c) => c['id'] != event.categoryId)
        .toList();

    emit(
      current.copyWith(
        categories: updated,
        totalWeight: _computeTotalWeight(updated),
      ),
    );
  }

  double _computeTotalWeight(List<Map<String, dynamic>> categories) {
    return categories.fold(0.0, (sum, c) => sum + (c['weight'] as double));
  }
}
