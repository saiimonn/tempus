import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/underline_text_field.dart';
import 'package:tempus/features/subjects/data/data_source/scores_remote_data_source.dart';
import 'package:tempus/features/subjects/data/data_source/subject_detail_remote_data_source.dart';
import 'package:tempus/features/subjects/data/data_source/subject_remote_data_source.dart';
import 'package:tempus/features/subjects/data/repositories/scores_repository_impl.dart';
import 'package:tempus/features/subjects/data/repositories/subject_detail_repository_impl.dart';
import 'package:tempus/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_scores.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subject_detail.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_score.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_subject.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject/subject_bloc.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject_detail/subject_detail_bloc.dart';
import 'package:tempus/features/subjects/presentation/pages/scores_page.dart';
import 'package:tempus/features/subjects/presentation/pages/subject_detail_page.dart';

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
        child: const _AddSubjectBottomSheet(),
      ),
    );
  }
}

class _SubjectCard extends StatefulWidget {
  final SubjectEntity subject;

  const _SubjectCard({required this.subject});

  @override
  State<_SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<_SubjectCard> {
  double? _estimatedGrade; // PH grade (1.0–5.0), null = loading
  double _gradePercent = 0; // raw % for the ring indicator

  @override
  void initState() {
    super.initState();
    _loadGrade();
  }

  Future<void> _loadGrade() async {
    try {
      final client = Supabase.instance.client;
      final repo = SubjectDetailRepositoryImpl(
        SubjectDetailRemoteDataSource(client),
        ScoresRemoteDataSource(client),
      );
      final detail = await repo.getSubjectDetail(widget.subject.id);
      if (mounted) {
        setState(() {
          _estimatedGrade = detail.estimatedGrade;
          _gradePercent = detail.estimatedPercent;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _estimatedGrade = 0.0);
    }
  }

  Color _gradeColor(double grade) {
    if (grade == 0.0) return AppColors.foreground; // no data
    if (grade <= 2.0) return AppColors.success;
    if (grade <= 3.0) return const Color(0xFFF59E0B);
    return AppColors.destructive; // 5.0 failing
  }

  double _ringValue(double grade) {
    if (grade == 0.0) return 0.0;
    // grade range 1.0–5.0 → invert so 1.0 → 1.0, 5.0 → 0.0
    return ((5.0 - grade) / 4.0).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    final grade = _estimatedGrade;
    final gradeColor = grade != null
        ? _gradeColor(grade)
        : AppColors.foreground;
    final ringVal = grade != null ? _ringValue(grade) : 0.0;
    final gradeLabel = (grade == null)
        ? '...'
        : (grade == 0.0 ? '--' : grade.toStringAsFixed(2));

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Subject info — Expanded so long names wrap instead of overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subject.code,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.brandBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.subject.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                        // Wrap gracefully instead of overflowing
                        softWrap: true,
                      ),

                      Row(
                        children: [
                          Text(
                            '${widget.subject.units} units',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground,
                            ),
                          ),
                          
                          const Gap(6),
                          
                          Text(
                            '•',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground,
                            ),
                          ),
                          
                          const Gap(6),
                          
                          Text(
                            widget.subject.instructor,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.foreground,
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Grade ring
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        gradeLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: gradeColor,
                        ),
                      ),
                    ],
                  ),
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
                      builder: (_) {
                        final repo = ScoresRepositoryImpl(
                          ScoresRemoteDataSource(client),
                        );
                        return BlocProvider<ScoresBloc>(
                          create: (_) => ScoresBloc(
                            getScores: GetScores(repo),
                            addScore: AddScore(repo),
                            updateScore: UpdateScore(repo),
                            deleteScore: DeleteScore(repo),
                          )..add(ScoresLoadRequested(widget.subject.id)),
                          child: ScoresPage(subject: widget.subject),
                        );
                      },
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
                          final detailRepo = SubjectDetailRepositoryImpl(
                            SubjectDetailRemoteDataSource(client),
                            ScoresRemoteDataSource(client),
                          );
                          final subjectRepo = SubjectRepositoryImpl(
                            SubjectRemoteDataSource(client),
                          );
                          return SubjectDetailBloc(
                            getSubjectDetail: GetSubjectDetail(detailRepo),
                            addGradeCategory: AddGradeCategory(detailRepo),
                            updateGradeCategory: UpdateGradeCategory(
                              detailRepo,
                            ),
                            deleteGradeCategory: DeleteGradeCategory(
                              detailRepo,
                            ),
                            updateSubject: UpdateSubject(subjectRepo),
                          )..add(SubjectDetailLoadRequested(widget.subject.id));
                        },
                        child: SubjectDetailPage(subject: widget.subject),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Subject Details',
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

class _AddSubjectBottomSheet extends StatefulWidget {
  const _AddSubjectBottomSheet();

  @override
  State<_AddSubjectBottomSheet> createState() => _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState extends State<_AddSubjectBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _profController = TextEditingController();
  final _unitsController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _profController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newSubject = SubjectEntity(
      id: 0,
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      instructor: _profController.text.trim(),
      units: int.parse(_unitsController.text.trim()),
    );

    context.read<SubjectBloc>().add(SubjectAddRequested(newSubject));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text(
                  'Add Subject',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),
                UnderlineTextField(
                  label: "Subject Name",
                  hint: "e.g. Data Structures and Algorithms",
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                UnderlineTextField(
                  label: "Instructor",
                  hint: "e.g. Christine Pena",
                  controller: _profController,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: UnderlineTextField(
                        label: "Subject Code",
                        hint: "e.g. CIS 2101",
                        controller: _codeController,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: UnderlineTextField(
                        label: "Units",
                        hint: "e.g. 3",
                        controller: _unitsController,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Req.';
                          if (int.tryParse(v) == null) return 'NaN';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      'Create Subject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
