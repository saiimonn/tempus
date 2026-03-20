import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/presentation/widgets/info_row.dart';

class InfoCard extends StatelessWidget {
  final ProfileEntity profile;

  const InfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Information',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
              letterSpacing: 0.3,
            ),
          ),

          const Gap(16),
          InfoRow(
            icon: Icons.badge_outlined,
            label: 'Student ID',
            value: profile.studentId.isNotEmpty ? profile.studentId : '-',
          ),

          const Gap(12),
          InfoRow(
            icon: Icons.school_outlined,
            label: 'Course',
            value: profile.course.isNotEmpty ? profile.course : '-',
          ),

          const Gap(12),
          InfoRow(
            icon: Icons.layers_outlined,
            label: 'Year Level',
            value: profile.yearLevel.isNotEmpty ? profile.yearLevel : '-',
          ),

          const Gap(12),
          InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile.email.isNotEmpty ? profile.email : '-',
          ),
        ],
      ),
    );
  }
}