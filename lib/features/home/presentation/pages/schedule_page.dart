import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class ClassEntry {
  String title;
  List<String> days; // e.g. ['Monday', 'Wednesday']
  TimeOfDay start;
  TimeOfDay end;
  String location;

  ClassEntry({
    required this.title,
    required this.days,
    required this.start,
    required this.end,
    required this.location,
  });
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<ClassEntry> _classes = [];

  Future<TimeOfDay?> _pickTime(TimeOfDay initial) async {
    return await showTimePicker(context: context, initialTime: initial);
  }

  Future<void> _showClassDialog({ClassEntry? entry, int? index}) async {
    final titleCtrl = TextEditingController(text: entry?.title ?? '');
    final locCtrl = TextEditingController(text: entry?.location ?? '');
    TimeOfDay start = entry?.start ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay end = entry?.end ?? const TimeOfDay(hour: 9, minute: 0);
    final initialDays = entry?.days ?? <String>[];

    final result = await showDialog<ClassEntry?>(
      context: context,
      builder: (context) {
        final selectedDays = <String>{...initialDays};
        return StatefulBuilder(builder: (context, dialogSetState) {
          return AlertDialog(
            title: Text(entry == null ? 'Add Class' : 'Edit Class'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final d in ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'])
                        FilterChip(
                          label: Text(d.substring(0,3)),
                          selected: selectedDays.contains(d),
                          onSelected: (v) => dialogSetState(() => v ? selectedDays.add(d) : selectedDays.remove(d)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final t = await _pickTime(start);
                          if (t != null) dialogSetState(() => start = t);
                        },
                        child: Text('Start: ${start.format(context)}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final t = await _pickTime(end);
                          if (t != null) dialogSetState(() => end = t);
                        },
                        child: Text('End: ${end.format(context)}'),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (selectedDays.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one day')));
                    return;
                  }

                  final newEntry = ClassEntry(
                    title: titleCtrl.text.trim(),
                    days: selectedDays.toList(),
                    start: start,
                    end: end,
                    location: locCtrl.text.trim(),
                  );

                  Navigator.of(context).pop(newEntry);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        if (entry == null) {
          _classes.add(result);
        } else if (index != null) {
          _classes[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Class Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showClassDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Class', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandBlue, foregroundColor: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_classes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: const [
                  Icon(Icons.schedule, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('No classes scheduled.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else ...[
            _buildTimetable(),
            const SizedBox(height: 16),
            const Text('Classes (tap to edit)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final c = _classes[i];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    onTap: () => _showClassDialog(entry: c, index: i),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${c.days.join(', ')} • ${c.start.format(context)} - ${c.end.format(context)}\n${c.location}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => setState(() => _classes.removeAt(i)),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Color _colorForEntry(ClassEntry c) {
    // deterministic hue based on entry content
    final key = '${c.title}|${c.location}|${c.days.join(',')}';
    final h = key.hashCode.abs() % 360;
    return HSVColor.fromAHSV(1, h.toDouble(), 0.55, 0.85).toColor();
  }

  Widget _buildTimetable() {
    // dynamic range: base on earliest class start and latest class end
    const rowHeight = 60.0; // height per hour
    final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

    double minStart = 7.5; // default 7:30
    double maxEnd = 21.0; // default 21:00

    if (_classes.isNotEmpty) {
      minStart = _classes.map((c) => c.start.hour + c.start.minute / 60.0).reduce((a, b) => math.min(a, b));
      maxEnd = _classes.map((c) => c.end.hour + c.end.minute / 60.0).reduce((a, b) => math.max(a, b));

      // add small padding
      minStart = math.max(0.0, minStart - 0.5);
      maxEnd = math.min(24.0, maxEnd + 0.5);

      // ensure at least 1 hour range
      if (maxEnd - minStart < 1.0) {
        final mid = (maxEnd + minStart) / 2.0;
        minStart = math.max(0.0, mid - 0.5);
        maxEnd = math.min(24.0, mid + 0.5);
      }
    }

    final minutesStart = (minStart * 60).toInt();
    final minutesEnd = (maxEnd * 60).toInt();

    const double topPadding = 8.0;
    final totalHeight = (maxEnd - minStart) * rowHeight + topPadding;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // header
          Row(children: [
            SizedBox(width: 60, height: 24),
            for (final d in days)
              Expanded(child: Center(child: Text(d.substring(0,3), style: const TextStyle(fontWeight: FontWeight.bold)))),
          ]),

          const SizedBox(height: 8),

          // grid area
          SizedBox(
            height: totalHeight + topPadding * 2,
            child: Row(children: [
              // time labels aligned with grid lines (every 30 minutes)
              SizedBox(
                width: 60,
                height: totalHeight + topPadding * 2,
                child: Stack(children: [
                  for (int m = minutesStart; m <= minutesEnd; m += 30)
                    Positioned(
                      top: math.max(0, topPadding + ((m - minutesStart) / 60) * rowHeight - 6),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          TimeOfDay(hour: (m ~/ 60) % 24, minute: m % 60).format(context),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    ),
                ]),
              ),

              // days columns
              for (int di = 0; di < days.length; di++)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.2)))),
                    child: Stack(children: [
                      // half-hour separators
                      for (int m = minutesStart; m <= minutesEnd; m += 30)
                        Positioned(
                          top: topPadding + ((m - minutesStart) / 60) * rowHeight,
                          left: 0,
                          right: 0,
                          child: Divider(height: 1, color: Colors.grey.withOpacity(0.25)),
                        ),

                      // class blocks
                      for (final c in _classes)
                        if (c.days.contains(days[di]))
                          Positioned(
                            top: topPadding + ((c.start.hour + c.start.minute / 60) - minStart) * rowHeight,
                            left: 0,
                            right: 0,
                            height: math.max(((c.end.hour + c.end.minute / 60) - (c.start.hour + c.start.minute / 60)) * rowHeight, 36.0),
                            child: GestureDetector(
                              onTap: () => _showClassDialog(entry: c, index: _classes.indexOf(c)),
                              child: Builder(builder: (context) {
                                final bg = _colorForEntry(c).withOpacity(0.95);
                                final textColor = bg.computeLuminance() > 0.55 ? Colors.black : Colors.white;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                    Text(
                                      c.title,
                                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c.location,
                                      style: TextStyle(color: textColor.withOpacity(0.85), fontSize: 9),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                );
                              }),
                            ),
                          ),
                    ]),
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}
