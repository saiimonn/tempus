import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';

class ScheduleEntryCard extends StatelessWidget {
  final ScheduleEntryEntity entry;

  const ScheduleEntryCard({super.key, required this.entry});

  String _fmtTime(String t) {
    final parts = t.split(':');
    final h = int.parse(parts[0]);
    final period = h >= 12 ? 'PM' : 'AM';
    final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$displayH:${parts[1]} $period';
  }

  String get _dayLabel {
    const abbr = {
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
      'Sunday': 'Sun',
    };
    const order = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final sorted = [...entry.days]
      ..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
    return sorted.map((d) => abbr[d]).join(', ');
  }

  Color get _entryColor {
    final key = '${entry.subjectCode}|${entry.subId}';
    final h = key.hashCode.abs() % 360;
    return HSVColor.fromAHSV(1, h.toDouble(), 0.55, 0.85).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final color = _entryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.subjectCode,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            entry.subjectName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: AppColors.foreground,
                              ),
                              const Gap(4),
                              Text(
                                '${_fmtTime(entry.startTime)} - ${_fmtTime(entry.endTime)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ],
                          ),
                          const Gap(2),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: AppColors.foreground,
                              ),
                              const Gap(4),
                              Text(
                                _dayLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.foreground,
                      ),
                      onPressed: () => context
                          .read<ScheduleBloc>()
                          .add(ScheduleEntryDeleteRequested(entry.id)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}