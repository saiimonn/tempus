import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/presentation/widgets/stat_chip.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.brandBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Gap(12),

            Text(
              profile.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Gap(4),

            Text(
              profile.email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),

            const Gap(16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatChip(
                  label: profile.course.isNotEmpty ? profile.course : '—',
                ),
                const Gap(8),
                StatChip(
                  label: profile.yearLevel.isNotEmpty
                      ? 'Year ${profile.yearLevel}'
                      : '—',
                ),
                const Gap(8),
                StatChip(
                  label: profile.studentId.isNotEmpty
                      ? profile.studentId
                      : '—',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}