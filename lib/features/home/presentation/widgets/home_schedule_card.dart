import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';

class HomeScheduleCard extends StatelessWidget {
  final List<ScheduleEntryEntity> entries;

  const HomeScheduleCard({
    super.key,
    required this.entries,
  });

  Color _dotColor(ScheduleEntryEntity entry) {
    final key = '${entry.subjectCode}|${entry.subId}';
    final hue = key.hashCode.abs() % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.6, 0.75).toColor();
  }

  String _fmtTime(String time) {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final period = h >= 12 ? 'PM' : 'AM';
    final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$displayH:${parts[1]} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Classes Today",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlue,
            ),
          ),

          const Gap(12),

          if(entries.isEmpty)
            _buildEmptyState()
          else 
            Column(
              children: entries
                .map((e) => _buildScheduleRow(e))
                .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(ScheduleEntryEntity e) {
    final color = _dotColor(e);
    final timeLabel =
        '${_fmtTime(e.startTime)} - ${_fmtTime(e.endTime)} | ${e.subjectCode}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.subjectName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Gap(2),

                Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 48,
              color: AppColors.foreground.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 10),
            const Text(
              'No classes scheduled today',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enjoy your free time!',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}