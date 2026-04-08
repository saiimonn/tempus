import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final Set<int> _expandedItems = {};

  static const List<_FaqCategory> _categories = [
    _FaqCategory(
      title: 'Getting Started',
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFF1A56DB),
      items: [
        _FaqItem(
          question: 'What is Tempus?',
          answer:
              'Tempus is a student productivity app designed for USC students. It helps you manage your class schedule, track tasks and assignments, monitor your budget, and calculate your estimated grades — all in one place.',
        ),
        _FaqItem(
          question: 'How do I create an account?',
          answer:
              'Tap "Sign up" on the login screen. You\'ll need your USC Student ID number and a password. Your account email will automatically be set to your school email (studentID@usc.edu.ph).',
        ),
        _FaqItem(
          question: 'Can I use Tempus without a USC student ID?',
          answer:
              'Tempus is currently designed exclusively for USC students. You need a valid USC student ID to register and use the app.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Tasks',
      icon: Icons.task_alt_outlined,
      color: Color(0xFF0E9F6E),
      items: [
        _FaqItem(
          question: 'How do I add a task?',
          answer:
              'Go to the Tasks tab and tap the blue "+" button in the bottom-right corner. Enter your task title, then optionally set a due date, due time, and link it to a subject.',
        ),
        _FaqItem(
          question: 'How do I mark a task as complete?',
          answer:
              'Tap the circle on the left side of any task tile to toggle it between pending and completed. Completed tasks will move to the "Completed" section.',
        ),
        _FaqItem(
          question: 'Can I edit or delete a task?',
          answer:
              'Yes. Tap the three-dot icon on a task tile or long-press it to open the context menu. From there you can choose Edit or Delete.',
        ),
        _FaqItem(
          question: 'What does "Past Due" mean?',
          answer:
              'Tasks whose due date has already passed but are not yet marked as complete appear in the "Past Due" section. These are highlighted in red to grab your attention.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Schedule',
      icon: Icons.calendar_today_outlined,
      color: Color(0xFF7C3AED),
      items: [
        _FaqItem(
          question: 'How do I add a class to my schedule?',
          answer:
              'Go to the Schedule tab and tap "Add Class". Select a subject from the dropdown, choose the days it meets, and set the start and end times. You must have subjects added first in the Subjects tab.',
        ),
        _FaqItem(
          question: 'Why can\'t I add a class without subjects?',
          answer:
              'Schedule entries are linked to subjects so your timetable stays organized and consistent with your grade tracking. Add your subjects in the Subjects tab first.',
        ),
        _FaqItem(
          question: 'How do I edit or remove a class?',
          answer:
              'Long-press any class block in the timetable view to open the options menu. You can edit the subject, days, or time, or delete the entry entirely.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Finance',
      icon: Icons.wallet_outlined,
      color: Color(0xFFF59E0B),
      items: [
        _FaqItem(
          question: 'How do I set my weekly budget?',
          answer:
              'In the Finance tab, go to the Budget section and tap the edit icon next to your weekly allowance. Enter your amount and tap Confirm.',
        ),
        _FaqItem(
          question: 'What happens when I add a transaction?',
          answer:
              'Income transactions increase your remaining balance, while expenses decrease it. The budget ring updates automatically to reflect how much of your weekly allowance you\'ve spent.',
        ),
        _FaqItem(
          question: 'What are subscriptions?',
          answer:
              'Subscriptions let you track recurring monthly costs like Netflix, Spotify, or other services. They don\'t affect your weekly budget automatically — they\'re for awareness and planning.',
        ),
        _FaqItem(
          question: 'Can I undo a deleted transaction?',
          answer:
              'No. Deleted transactions are permanently removed. Be careful before confirming a deletion.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Subjects & Grades',
      icon: Icons.school_outlined,
      color: Color(0xFFEF4444),
      items: [
        _FaqItem(
          question: 'How does the grade calculator work?',
          answer:
              'Each subject has grade categories (e.g., Quizzes, Midterm, Finals) with assigned weights. You enter your scores for each category, and Tempus computes your weighted average and converts it to the Philippine university grading scale (1.0–5.0).',
        ),
        _FaqItem(
          question: 'What does an estimated grade of 5.0 mean?',
          answer:
              '5.0 is the failing grade on the Philippine university scale. It appears when your weighted average falls below 75%. A grade of 1.0 is the highest.',
        ),
        _FaqItem(
          question:
              'My total category weight doesn\'t add up to 100%. Is that a problem?',
          answer:
              'Yes. For the most accurate grade estimate, your category weights should total exactly 100%. Tempus will warn you if they\'re over or under. The grade calculation will still run but may be less accurate.',
        ),
        _FaqItem(
          question: 'Can I delete a subject?',
          answer:
              'Subject deletion is not currently supported. You can edit a subject\'s name, code, instructor, and units, as well as manage its grade categories.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Account & Profile',
      icon: Icons.person_outline,
      color: Color(0xFF64748B),
      items: [
        _FaqItem(
          question: 'Can I change my student ID or email?',
          answer:
              'No. Your student ID and school email are tied to your account and cannot be changed. If you registered with the wrong ID, you\'ll need to create a new account.',
        ),
        _FaqItem(
          question: 'How do I update my name, course, or year level?',
          answer:
              'Go to your Profile page and tap the Edit button in the top-right corner. You can update your full name, course, and year level there.',
        ),
        _FaqItem(
          question: 'How do I sign out?',
          answer:
              'Open the Profile page and scroll to the bottom. Tap the "Sign Out" button. You\'ll be returned to the login screen.',
        ),
      ],
    ),
  ];

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

        title: const Text(
          'Help & FAQ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A56DB), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                const Gap(16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How can we help?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const Gap(4),

                      Text(
                        'Browse frequently asked questions below',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),

          ..._categories.map(
            (category) => _CategorySection(
              category: category,
              expandedItems: _expandedItems,
              onToggle: (globalIdx) {
                setState(() {
                  if (_expandedItems.contains(globalIdx)) {
                    _expandedItems.remove(globalIdx);
                  } else {
                    _expandedItems.add(globalIdx);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final _FaqCategory category;
  final Set<int> expandedItems;
  final void Function(int) onToggle;

  const _CategorySection({
    required this.category,
    required this.expandedItems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, size: 16, color: category.color),
              ),

              const Gap(10),

              Text(
                category.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: category.color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),

          const Gap(10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              children: List.generate(category.items.length, (i) {
                final globalIdx = category.hashCode ^ i;
                final isExpanded = expandedItems.contains(globalIdx);
                final isLast = i == category.items.length - 1;

                return Column(
                  children: [
                    InkWell(
                      onTap: () => onToggle(globalIdx),
                      borderRadius: BorderRadius.only(
                        topLeft: i == 0
                            ? const Radius.circular(14)
                            : Radius.zero,
                        topRight: i == 0
                            ? const Radius.circular(14)
                            : Radius.zero,
                        bottomLeft: isLast
                            ? const Radius.circular(14)
                            : Radius.zero,
                        bottomRight: isLast
                            ? const Radius.circular(14)
                            : Radius.zero,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category.items[i].question,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),

                                const Gap(8),

                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: isExpanded
                                        ? category.color
                                        : AppColors.foreground,
                                  ),
                                ),
                              ],
                            ),

                            AnimatedCrossFade(
                              firstChild: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  category.items[i].answer,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.foreground,
                                    height: 1.6,
                                  ),
                                ),
                              ),

                              secondChild: const SizedBox.shrink(),

                              crossFadeState: isExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 220),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade100,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_FaqItem> items;

  const _FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
