// used in schedule_page.dart -> ScheduleContent()
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/data/schedule_model.dart';

class TimeTableGrid extends StatelessWidget {
  final List<ScheduleEntry> entries;

  const TimeTableGrid({super.key, required this.entries});

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _rowHeight = 56.0;

  List<String> get _activeDays {
    final used = <String>{};
    for (final e in entries) {
      used.addAll(e.days);
    }
    return _days.where((d) => used.contains(d)).toList();
  }

  double _timeToHour(String t) {
    final parts = t.split(':');
    return int.parse(parts[0]) + int.parse(parts[1]) / 60.0;
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeDays;
    if (active.isEmpty) return const Gap(0);

    double minH = entries
        .map((e) => _timeToHour(e.startTime))
        .reduce((a, b) => math.min(a, b));

    double maxH = entries
        .map((e) => _timeToHour(e.endTime))
        .reduce((a, b) => math.max(a, b));

    minH = math.max(0, minH - 0.5);
    maxH = math.min(24, maxH + 0.5);

    if (maxH - minH < 1) {
      minH = math.max(0, (minH + maxH) / 2 - 0.5);
      maxH = math.min(24, (minH + maxH) / 2 + 0.5);
    }

    final totalH = maxH - minH;
    const topPad = 8.0;
    final gridH = totalH * _rowHeight + topPad * 2;

    final marks = <double>[];
    for (double h = (minH * 2).ceil() / 2; h < maxH; h += 0.5) {
      marks.add(h);
    }

    String fmtMark(double h) {
      final hour = h.floor();
      final min = ((h - hour) * 60).round();
      final t = TimeOfDay(hour: hour, minute: min);
      final hDisplay = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final mDisplay = min.toString().padLeft(2, '0');
      final p = t.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hDisplay:$mDisplay $p';
    }

    Color entryColor(ScheduleEntry e) {
      final key = '${e.subjectCode}|${e.subId}';
      final hue = key.hashCode.abs() % 360;
      return HSVColor.fromAHSV(1, hue.toDouble(), 0.55, 0.85).toColor();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Gap(52),
              ...active.asMap().entries.map((e) {
                final abbr = _dayAbbr[_days.indexOf(e.value)];
                return Expanded(
                  child: Center(
                    child: Text(
                      abbr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          Gap(6),

          SizedBox(
            height: gridH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 52,
                  child: Stack(
                    children: marks.map((h) {
                      final top = topPad + (h - minH) * _rowHeight - 7;
                      return Positioned(
                        top: top,
                        left: 0,
                        right: 2,
                        child: Text(
                          fmtMark(h),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.foreground,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                ...active.map((day) {
                  final dayEntries = entries
                      .where((e) => e.days.contains(day))
                      .toList();

                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          ...marks.map((h) {
                            return Positioned(
                              top: topPad + (h - minH) * _rowHeight,
                              left: 0,
                              right: 0,
                              child: Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.15),
                              ),
                            );
                          }),

                          ...dayEntries.map((e) {
                            final top =
                                topPad +
                                (_timeToHour(e.startTime) - minH) * _rowHeight;
                            final height = math.max(
                              (_timeToHour(e.endTime) -
                                      _timeToHour(e.startTime)) *
                                  _rowHeight,
                              28.0,
                            );

                            final bg = entryColor(e);
                            final textColor = bg.computeLuminance() > 0.55
                                ? Colors.black87
                                : Colors.white;

                            return Positioned(
                              top: top,
                              left: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  e.subjectCode,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
