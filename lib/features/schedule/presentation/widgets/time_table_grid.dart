import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';

class TimetableGrid extends StatelessWidget {
  final ScheduleLoaded state;

  const TimetableGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _DayNavHeader(state: state),
          const Divider(height: 1, thickness: 0.8, color: Color(0xFFEEEEEE)),
          _DayTimeline(state: state),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day navigation header
// ---------------------------------------------------------------------------

class _DayNavHeader extends StatelessWidget {
  final ScheduleLoaded state;

  static const _abbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  const _DayNavHeader({required this.state});

  bool _isToday(int idx) => (DateTime.now().weekday - 1) == idx;

  @override
  Widget build(BuildContext context) {
    final idx = state.selectedDayIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Row(
        children: [
          _NavArrow(
            icon: Icons.chevron_left_rounded,
            enabled: idx > 0,
            onTap: () => context
                .read<ScheduleBloc>()
                .add(ScheduleDayPrevRequested()),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (i) {
                final selected = i == idx;
                final today = _isToday(i);

                return GestureDetector(
                  onTap: () => context
                      .read<ScheduleBloc>()
                      .add(ScheduleDaySelected(i)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 36,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.brandBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _abbr[i],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? Colors.white
                                : AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: today
                                ? (selected
                                    ? Colors.white
                                    : AppColors.brandBlue)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          _NavArrow(
            icon: Icons.chevron_right_rounded,
            enabled: idx < 6,
            onTap: () => context
                .read<ScheduleBloc>()
                .add(ScheduleDayNextRequested()),
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          icon,
          size: 26,
          color: enabled ? AppColors.text : Colors.grey.shade300,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day timeline
// ---------------------------------------------------------------------------

class _DayTimeline extends StatelessWidget {
  final ScheduleLoaded state;

  static const double _hourHeight = 64.0;
  static const double _timeColWidth = 54.0;
  static const int _startHour = 6;
  static const int _endHour = 22;
  static const int _totalHours = _endHour - _startHour;

  const _DayTimeline({required this.state});

  double _toOffset(String t) {
    final p = t.split(':');
    return (int.parse(p[0]) + int.parse(p[1]) / 60.0 - _startHour) *
        _hourHeight;
  }

  String _fmtHour(int h) {
    if (h == 0) return '12 AM';
    if (h < 12) return '$h AM';
    if (h == 12) return '12 PM';
    return '${h - 12} PM';
  }

  String _fmtTime(String t) {
    final p = t.split(':');
    final h = int.parse(p[0]);
    final period = h >= 12 ? 'PM' : 'AM';
    final dh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$dh:${p[1]} $period';
  }

  Color _entryColor(ScheduleEntryEntity e) {
    final key = '${e.subjectCode}|${e.subId}';
    final hue = key.hashCode.abs() % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.60, 0.82).toColor();
  }

  List<_PositionedEntry> _resolve(List<ScheduleEntryEntity> entries) {
    if (entries.isEmpty) return [];

    final sorted = [...entries]
      ..sort(
          (a, b) => _toOffset(a.startTime).compareTo(_toOffset(b.startTime)));

    final List<double> colEnds = [];
    final Map<int, int> colMap = {};

    for (final e in sorted) {
      final start = _toOffset(e.startTime);
      final end = _toOffset(e.endTime);
      int placed = -1;
      for (int c = 0; c < colEnds.length; c++) {
        if (colEnds[c] <= start) {
          colEnds[c] = end;
          placed = c;
          break;
        }
      }
      if (placed == -1) {
        placed = colEnds.length;
        colEnds.add(end);
      }
      colMap[e.id] = placed;
    }

    final numCols = colEnds.length;

    return sorted.map((e) {
      final top = _toOffset(e.startTime);
      final height = math.max(_toOffset(e.endTime) - top, 30.0);
      return _PositionedEntry(
        entry: e,
        top: top,
        height: height,
        col: colMap[e.id]!,
        totalCols: numCols,
        color: _entryColor(e),
        startLabel: _fmtTime(e.startTime),
        endLabel: _fmtTime(e.endTime),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = state.entriesForSelectedDay;
    final positioned = _resolve(entries);
    final gridHeight = _totalHours * _hourHeight;

    return SizedBox(
      height: 420,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 4),
          child: SizedBox(
            height: gridHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final eventsWidth =
                    constraints.maxWidth - _timeColWidth - 8;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time labels column
                    SizedBox(
                      width: _timeColWidth,
                      child: Stack(
                        children: List.generate(_totalHours + 1, (i) {
                          return Positioned(
                            top: i * _hourHeight - 7.0,
                            left: 0,
                            right: 4,
                            child: Text(
                              _fmtHour(_startHour + i),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 9.5,
                                color: AppColors.foreground
                                    .withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Events column
                    SizedBox(
                      width: eventsWidth,
                      child: Stack(
                        children: [
                          // Hour dividers
                          ...List.generate(
                            _totalHours + 1,
                            (i) => Positioned(
                              top: i * _hourHeight,
                              left: 0,
                              right: 0,
                              child: Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey.withValues(alpha: 0.20),
                              ),
                            ),
                          ),

                          // Half-hour dividers
                          ...List.generate(
                            _totalHours,
                            (i) => Positioned(
                              top: i * _hourHeight + _hourHeight / 2,
                              left: 0,
                              right: 0,
                              child: Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey.withValues(alpha: 0.08),
                              ),
                            ),
                          ),

                          // Empty state
                          if (entries.isEmpty)
                            Positioned(
                              top: gridHeight / 2 - 40,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_available_outlined,
                                    size: 32,
                                    color: AppColors.foreground
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'No classes today',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.foreground
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Entry blocks
                          ...positioned.map((p) {
                            final colWidth = eventsWidth / p.totalCols;
                            final left = p.col * colWidth + 2;
                            final width = colWidth - 4;
                            final tc = p.color.computeLuminance() > 0.4
                                ? Colors.black87
                                : Colors.white;

                            return Positioned(
                              top: p.top + 1,
                              left: left,
                              width: width,
                              height: p.height - 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: p.color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.entry.subjectCode,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: tc,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (p.height > 38)
                                      Text(
                                        '${p.startLabel} – ${p.endLabel}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: tc.withValues(alpha: 0.85),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal layout model
// ---------------------------------------------------------------------------

class _PositionedEntry {
  final ScheduleEntryEntity entry;
  final double top;
  final double height;
  final int col;
  final int totalCols;
  final Color color;
  final String startLabel;
  final String endLabel;

  const _PositionedEntry({
    required this.entry,
    required this.top,
    required this.height,
    required this.col,
    required this.totalCols,
    required this.color,
    required this.startLabel,
    required this.endLabel,
  });
}