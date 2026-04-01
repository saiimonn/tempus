import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_score_sheet.dart';
import 'package:tempus/features/subjects/presentation/widgets/score_section.dart';

const _fakeCategories = [
  GradeCategoryEntity(id: 1, name: 'Loading Category', weight: 40),
  GradeCategoryEntity(id: 2, name: 'Loading Category', weight: 30),
  GradeCategoryEntity(id: 3, name: 'Loading Category', weight: 30),
];

final _fakeScores = {
  1: const [
    ScoresEntity(id: 1, title: 'Loading Score Item', scoreValue: 42, maxScore: 50),
    ScoresEntity(id: 2, title: 'Loading Score Item', scoreValue: 18, maxScore: 20),
  ],
  2: const [
    ScoresEntity(id: 3, title: 'Loading Score Item', scoreValue: 24, maxScore: 30),
  ],
  3: const [
    ScoresEntity(id: 4, title: 'Loading Score Item', scoreValue: 90, maxScore: 100),
  ],
};

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
                fontWeight: FontWeight.w600,
                color: AppColors.brandBlue,
              ),
            ),
            Text(
              subject.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ScoresBloc, ScoresState>(
        builder: (context, state) {
          if (state is ScoresError) {
            return Center(child: Text(state.message));
          }

          final isLoading = state is ScoresInitial || state is ScoresLoading;
          final loaded = state is ScoresLoaded
              ? state
              : ScoresLoaded(
                  categories: _fakeCategories,
                  scores: _fakeScores,
                  expandedCategories: _fakeCategories.map((c) => c.id).toSet(),
                );

          return Skeletonizer(
            enabled: isLoading,
            child: _ScoresContent(
              state: loaded,
              subject: subject,
              isLoading: isLoading,
            ),
          );
        },
      ),
    );
  }
}

class _ScoresContent extends StatelessWidget {
  final ScoresLoaded state;
  final SubjectEntity subject;
  final bool isLoading;

  const _ScoresContent({
    required this.state,
    required this.subject,
    required this.isLoading,
  });

  void _showAddScoreSheet(BuildContext context, int categoryId) {
    final scoresBloc = context.read<ScoresBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: scoresBloc,
        child: AddScoreSheet(categoryId: categoryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading && state.categories.isEmpty) {
      return _buildNoCategories();
    }

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Scores',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  state.categories.map((c) {
                    final isExpanded = state.expandedCategories.contains(c.id);
                    final catScores = state.scores[c.id] ?? [];

                    return ScoreSection(
                      category: c,
                      scores: catScores,
                      isExpanded: isExpanded,
                      onToggle: () {
                        if (isLoading) return;
                        context
                            .read<ScoresBloc>()
                            .add(ScoresCategoryToggled(c.id));
                      },
                      onAdd: () {
                        if (isLoading) return;
                        _showAddScoreSheet(context, c.id);
                      },
                      onDeleteScore: (scoreId) => isLoading
                          ? null
                          : context.read<ScoresBloc>().add(
                                ScoresDeleteRequested(
                                  categoryId: c.id,
                                  scoreId: scoreId,
                                ),
                              ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 70,
          right: 20,
          child: _AddScoreFab(
            categories: state.categories
                .map((c) => (id: c.id, name: c.name))
                .toList(),
            onSelected: (categoryId) {
              if (isLoading) return;
              _showAddScoreSheet(context, categoryId);
            },
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildNoCategories() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 60,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),
          const Gap(16),
          const Text(
            'No Grade Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          const Gap(4),
          const Text(
            'Set up grade categories in Manage Grading',
            style: TextStyle(fontSize: 12, color: AppColors.foreground),
          ),
        ],
      ),
    );
  }
}

class _AddScoreFab extends StatelessWidget {
  final List<({int id, String name})> categories;
  final void Function(int categoryId) onSelected;
  final bool isLoading;

  const _AddScoreFab({
    required this.categories,
    required this.onSelected,
    this.isLoading = false,
  });

  void _handleTap(BuildContext context) {
    if (categories.isEmpty) return;

    if (categories.length == 1) {
      onSelected(categories.first.id);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryPickerSheet(
        categories: categories,
        onSelected: (id) {
          Navigator.of(context).pop();
          onSelected(id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'scores_fab',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      onPressed: isLoading ? null : () => _handleTap(context),
      backgroundColor: AppColors.brandBlue,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class _CategoryPickerSheet extends StatelessWidget {
  final List<({int id, String name})> categories;
  final void Function(int id) onSelected;

  const _CategoryPickerSheet({
    required this.categories,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 22, color: AppColors.text),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Add Score to...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
            ],
          ),
          const SizedBox(height: 8),
          ...categories.map(
            (c) => InkWell(
              onTap: () => onSelected(c.id),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.brandBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      c.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}