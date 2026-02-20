// used in scores_page -> _showAddScoreSheet()
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/custom_text_field.dart';
import 'package:tempus/features/subjects/logic/scores_bloc.dart';

class AddScoreSheet extends StatefulWidget {
  final int categoryId;

  const AddScoreSheet({super.key, required this.categoryId});

  @override
  State<AddScoreSheet> createState() => AddScoreSheetState();
}

class AddScoreSheetState extends State<AddScoreSheet> {
  final _titleController = TextEditingController();
  final _scoreController = TextEditingController();
  final _maxScoreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _scoreController.dispose();
    _maxScoreController.dispose();
    super.dispose();
  }

  void _confirm() {
    if(!_formKey.currentState!.validate()) return;

    final score = double.parse(_scoreController.text.trim());
    final maxScore = double.parse(_maxScoreController.text.trim());

    if (score > maxScore) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Score cannot exceed max state"),
          backgroundColor: AppColors.destructive,
        ),
      );
      return;
    }

    context.read<ScoresBloc>().add(
      AddScore(
        categoryId: widget.categoryId,
        title: _titleController.text.trim(),
        scoreValue: score,
        maxScore: maxScore,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Add Score",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
                Gap(22),
              ],
            ),
            Gap(24),

            CustomTextField(
              controller: _titleController,
              label: "Score Title *",
              hint: "e.g. Quiz 1",
              validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
            ),

            Gap(16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _scoreController,
                        label: "Score *",
                        hint: "e.g. 38",
                        isDecimal: true,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Required";
                          if (double.tryParse(v.trim()) == null) {
                            return "Invalid";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Gap(12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _maxScoreController,
                        label: "Max Score *",
                        hint: "e.g. 40",
                        isDecimal: true,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Required";
                          final d = double.tryParse(v.trim());
                          if (d == null || d <= 0) return "Invalid";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap(28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}