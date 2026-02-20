import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/logic/subject_detail_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/empty_categories.dart';
import 'package:tempus/features/subjects/presentation/widgets/estimated_grade_card.dart';
import 'package:tempus/features/subjects/presentation/widgets/category_tile.dart';

class SubjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SubjectDetailBloc()..add(LoadSubjectDetail(
            subject['id'] is int ? subject['id'] : int.tryParse(subject['id'].toString()) ?? 0          )
        ),
      child: _SubjectDetailView(subject: subject),
    );
  }
}

class _SubjectDetailView extends StatelessWidget {
  final Map<String, dynamic> subject;

  const _SubjectDetailView({super.key, required this.subject});

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
                fontSize: 16,
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              "${subject['name']}",
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: BlocBuilder<SubjectDetailBloc, SubjectDetailState>(
        builder: (context, state) {
          if (state is SubjectDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is SubjectDetailLoaded) {
            return _buildContent(context, state);
          }

          return const Center(child: Text("Failed to load subject details."));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SubjectDetailLoaded state) {
    final bool isOver100 = state.totalWeight > 100;
    final bool isExact100 = (state.totalWeight - 100).abs() < 0.01;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        EstimatedGradeCard(grade: state.estimatedGrade),
        
        const SizedBox(height: 20),
        
        const Text(
          "Active Categories",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        
        const SizedBox(height: 12),
        
        if (state.categories.isEmpty) 
          EmptyCategories()
        else
          ...state.categories.map(
            (cat) => CategoryTile(
              category: cat,
              onDelete: () => context
                .read<SubjectDetailBloc>()
                .add(DeleteGradeCategory(cat['id'] as int)),
            ),
          ),
          
        const SizedBox(height: 8),
        
        
      ],
    );
  }
}
