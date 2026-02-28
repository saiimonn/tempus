import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_score_sheet.dart';
import 'package:tempus/features/subjects/presentation/widgets/category_section.dart';

class ScoresPage extends StatelessWidget {
  final SubjectEntity subject;

  const ScoresPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.code,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subject.name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ScoresBloc, ScoresState>(
        builder: (context, state) {
          return switch (state) {
            ScoresLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.brandBlue),
              ),
            ScoresLoaded() => _buildContent(context, state),
            ScoresError(:final message) => Center(child: Text(message)),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ScoresLoaded state) {
    if (state.categories.isEmpty) return _buildNoCategories();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: state.categories.map((category) {
        final isExpanded = state.expandedCategories.contains(category.id);
        final catScores = state.scores[category.id] ?? [];

        return CategorySection(
          category: category,
          scores: catScores,
          isExpanded: isExpanded,
          onToggle: () => context
              .read<ScoresBloc>()
              .add(ScoresCategoryToggled(category.id)),
          onAddScore: () => _showAddScoreSheet(context, category.id),
          onDeleteScore: (scoreId) => context.read<ScoresBloc>().add(
                ScoresDeleteRequested(
                  categoryId: category.id,
                  scoreId: scoreId,
                ),
              ),
        );
      }).toList(),
    );
  }

  Widget _buildNoCategories() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 48, color: AppColors.foreground),
          const SizedBox(height: 8),
          Text(
            'No Grade Categories',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Set up grade categories in Manage Grading',
            style: TextStyle(fontSize: 16, color: AppColors.foreground),
          ),
        ],
      ),
    );
  }

  void _showAddScoreSheet(BuildContext context, int categoryId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ScoresBloc>(),
        child: AddScoreSheet(categoryId: categoryId),
      ),
    );
  }
}