import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_score_sheet.dart';
import 'package:tempus/features/subjects/presentation/widgets/score_section.dart';

class ScoresPage extends StatelessWidget {
  final SubjectEntity subject;

  const ScoresPage({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.text,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.code,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.brandBlue,
              ),
            ),

            Text(
              subject.name,
              style: TextStyle(
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
          return switch(state) {
            ScoresLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            ),
            ScoresLoaded() => _ScoresContent(state: state, subject: subject),
            ScoresError(: final message) => Center(child: Text(message)),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ScoresContent extends StatelessWidget {
  final ScoresLoaded state;
  final SubjectEntity subject;

  const _ScoresContent({
    required this.state,
    required this.subject,
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
    if (state.categories.isEmpty) {
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
                      onToggle: () => context
                        .read<ScoresBloc>()
                        .add(ScoresCategoryToggled(c.id)),
                      onAdd: () => _showAddScoreSheet(context, c.id),
                      onDeleteScore: (scoreId) =>
                        context.read<ScoresBloc>().add(
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
          bottom: 20,
          right: 20,
          child: _AddScoreFab(
            categories: state.categories
              .map((c) => (id: c.id, name: c.name))
              .toList(),
            onSelected: (categoryId) => 
              _showAddScoreSheet(context, categoryId),
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
            style: TextStyle(
              fontSize: 12,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddScoreFab extends StatelessWidget {
  final List<({int id, String name})> categories;
  final void Function(int categoryId) onSelected;

  const _AddScoreFab({
    required this.categories,
    required this.onSelected,
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
      onPressed: () => _handleTap(context),
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
                child:
                    const Icon(Icons.close, size: 22, color: AppColors.text),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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