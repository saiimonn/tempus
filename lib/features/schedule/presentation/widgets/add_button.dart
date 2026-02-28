import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/widgets/add_schedule_sheet.dart';

class AddButton extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const AddButton({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.brandBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            Gap(4),
            Text(
              'Add Class',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleBloc>(),
        child: AddScheduleSheet(subjects: subjects),
      ),
    );
  }
}