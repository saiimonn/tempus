import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/logic/scores_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_score_sheet.dart';
import 'package:tempus/features/subjects/presentation/widgets/category_section.dart';

class ScoresPage extends StatelessWidget {
  final Map<String, dynamic> subject;

  const ScoresPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoresBloc()..add(LoadScores(int.parse(subject['id'].toString()))),
      child: _ScoresView(subject: subject),
    );
  }
}

class _ScoresView extends StatelessWidget {
  final Map<String, dynamic> subject;

  const _ScoresView({required this.subject});

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
              "${subject['code']}",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              "${subject['name']}",
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: BlocBuilder<ScoresBloc, ScoresState> (
        builder: (context, state) {
          if (state is ScoresLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is ScoresLoaded) {
            if(state.categories.isEmpty) {
              return _buildNoCategories();
            }
            return _buildContent(context, state);
          }

          return const Center(child: Text("Failed to load scores."));
        },
      ),
    );
  }

  Widget _buildNoCategories() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: AppColors.foreground,
          ),

          const SizedBox(height: 8),

          Text(
            "No Grade Categories",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Set up grade categories in Manage Grading",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ScoresLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: state.categories.map((category) {
        final int catId = category['id'] as int;
        final bool isExpanded = state.expandedCategories.contains(catId);
        final List<Map<String, dynamic>> catScores = state.scores[catId] ?? [];

        return CategorySection(
          category: category,
          scores: catScores,
          isExpanded: isExpanded,
          onToggle: () => context.read<ScoresBloc>().add(ToggleCategory(catId)),
          onAddScore: () => _showAddScoreSheet(context, catId),
          onDeleteScore: (scoreId) => context.read<ScoresBloc>().add(
            DeleteScore(categoryId: catId, scoreId: scoreId)
          ),
        );
      }).toList(),
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