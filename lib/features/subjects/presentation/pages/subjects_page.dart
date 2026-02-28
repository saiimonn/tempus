import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/data/data_source/scores_local_data_source.dart';
import 'package:tempus/features/subjects/data/data_source/subject_detail_local_data_source.dart';
import 'package:tempus/features/subjects/data/repositories/scores_repository_impl.dart';
import 'package:tempus/features/subjects/data/repositories/subject_detail_repository_impl.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_scores.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subject_detail.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject/subject_bloc.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject_detail/subject_detail_bloc.dart';
import 'package:tempus/features/subjects/presentation/pages/scores_page.dart';
import 'package:tempus/features/subjects/presentation/pages/subject_detail_page.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_category_sheet.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state is SubjectLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is SubjectLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.subjects.length + 1,
              itemBuilder: (context, index) {
                if (index == state.subjects.length) {
                  return _AddSubjectCard(
                    onTap: () => _showAddSubjectSheet(context),
                  );
                }
                return _SubjectCard(subject: state.subjects[index]);
              },
            );
          }

          return const Center(child: Text('No Subjects Found'));
        },
      ),
    );
  }

  void _showAddSubjectSheet(BuildContext context) {
    final bloc = context.read<SubjectBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const AddCategorySheet(),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectEntity subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.code,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${subject.units} units',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.92,
                        strokeWidth: 6,
                        color: AppColors.success,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    const Text(
                      '92%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withAlpha(80), height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<ScoresBloc>(
                        create: (_) {
                          final repo = ScoresRepositoryImpl(
                            ScoresLocalDataSource(),
                          );
                          return ScoresBloc(
                            getScores: GetScores(repo),
                            addScore: AddScore(repo),
                            deleteScore: DeleteScore(repo),
                          )..add(ScoresLoadRequested(int.parse(subject.id)));
                        },
                        child: ScoresPage(subject: subject),
                      ),
                    ),
                  ),
                  child: const Text(
                    'View Scores',
                    style: TextStyle(color: AppColors.brandBlue),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<SubjectDetailBloc>(
                        create: (_) {
                          final repo = SubjectDetailRepositoryImpl(
                            SubjectDetailLocalDataSource(),
                          );
                          return SubjectDetailBloc(
                            getSubjectDetail: GetSubjectDetail(repo),
                            addGradeCategory: AddGradeCategory(repo),
                            deleteGradeCategory: DeleteGradeCategory(repo),
                          )..add(SubjectDetailLoadRequested(subject.id));
                        },
                        child: SubjectDetailPage(subject: subject),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Manage Grading',
                    style: TextStyle(color: AppColors.brandBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSubjectCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddSubjectCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 32, color: Colors.blueGrey.shade400),
              const SizedBox(height: 8),
              Text(
                'Add Subject',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}