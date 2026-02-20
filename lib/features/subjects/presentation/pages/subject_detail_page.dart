import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/logic/subject_detail_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_category_sheet.dart';
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
        _buildEstimatedGradeCard(state.estimatedGrade),
        
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
          _buildEmptyCategories()
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
        
        _buildAddCategoryCard(context),

        const SizedBox(height: 20),

        _buildInfoCard(),

        const SizedBox(height: 16),

        _buildWeightInfo(
          context,
          totalWeight: state.totalWeight,
          isExact100: isExact100,
          isOver100: isOver100,
        ),
      ],
    );
  }

  Widget _buildEstimatedGradeCard(double grade) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),

      child: Column(
        children: [
          const Text(
            "Current Estimated Grade",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            grade.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlue,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildEmptyCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),

          const SizedBox(height: 12),

          const Text(
            "No grade categories yet",
            style: TextStyle(color: AppColors.foreground, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryCard(BuildContext context) {
    return InkWell(
      onTap: () => _showAddCategorySheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 28, color: Colors.blueGrey.shade400),
            const SizedBox(height: 4),
            Text(
              "Add Grade Category",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.brandBlue.withValues(alpha: 0.5)),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(Icons.info_outline, color: AppColors.brandBlue, size: 20)
          ),

          Expanded(
            flex: 4,
            child: Text(
              "Your grades will be calculated using the weighted average method. Ensure all categories' weights account for 100% of your total grade, otherwise calculations will occur if not.",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.brandBlue,
              )
            )
          )
        ]
      ),
    );
  }

  Widget _buildWeightInfo(
    BuildContext context, {
    required double totalWeight,
    required bool isOver100,
    required bool isExact100,
  }) {
      final Color dotColor = isOver100
        ? AppColors.destructive : isExact100 ? const Color(0xFF0E9F6E) : const Color(0xFFF59E0B);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
        ),

        child: Column(
          children: [
            Row(
              spacing: 4,
              children: [
                const Text(
                  "Total Weight",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),

                Spacer(),

                Text(
                  "${totalWeight.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOver100 ? AppColors.destructive : AppColors.text,
                  ),
                ),
              ],
            ),

            if(!isExact100) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: AppColors.destructive,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Total weight exceeds 100%. Please adjust category weights.",
                      style: TextStyle(
                      fontSize: 12,
                      color: AppColors.destructive
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if(!isOver100 && !isExact100) ...[
              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.warning_amber_outlined, size: 14, color: AppColors.destructive),
                  const SizedBox(height: 6),

                  Text(
                    "Missing ${(totalWeight - 100).abs().toStringAsFixed(0)}% to reach full allocation",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.destructive,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
  }

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SubjectDetailBloc>(),
        child: const AddCategorySheet(),
      ),
    );
  }
}
