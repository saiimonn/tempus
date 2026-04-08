import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String _appVersion = '1.0.0';
  static const String _buildNumber = '1';

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
          'About Tempus',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
        children: [
          // Logo & hero card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A56DB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // App icon placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/tempuslogo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.timer_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
                const Gap(16),
                const Text(
                  'TEMPUS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const Gap(6),
                Text(
                  'Student Productivity App',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const Gap(16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'Version $_appVersion (Build $_buildNumber)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),

          // Mission
          _InfoCard(
            icon: Icons.flag_outlined,
            iconColor: AppColors.brandBlue,
            title: 'Our Mission',
            child: const _BodyText(
              'Tempus was built to help USC students stay on top of their academic life without the chaos. We believe that when students have the right tools — organized schedules, clear task lists, budget awareness, and grade insights — they can focus on what actually matters: learning.',
            ),
          ),

          const Gap(16),

          // What Tempus offers
          _InfoCard(
            icon: Icons.auto_awesome_outlined,
            iconColor: const Color(0xFF7C3AED),
            title: 'What Tempus Offers',
            child: Column(
              children: const [
                _FeatureRow(
                  icon: Icons.task_alt_rounded,
                  color: Color(0xFF0E9F6E),
                  label: 'Task Management',
                  description:
                      'Organize assignments by subject with due dates and time tracking.',
                ),
                _FeatureRow(
                  icon: Icons.calendar_today_rounded,
                  color: Color(0xFF1A56DB),
                  label: 'Class Schedule',
                  description:
                      'View your weekly timetable with a clear day-by-day layout.',
                ),
                _FeatureRow(
                  icon: Icons.wallet_rounded,
                  color: Color(0xFFF59E0B),
                  label: 'Finance Tracker',
                  description:
                      'Monitor your weekly allowance, expenses, and subscriptions.',
                ),
                _FeatureRow(
                  icon: Icons.school_rounded,
                  color: Color(0xFFEF4444),
                  label: 'Grade Calculator',
                  description:
                      'Track scores per category and estimate your final grade.',
                  isLast: true,
                ),
              ],
            ),
          ),

          const Gap(16),

          // Tech stack
          _InfoCard(
            icon: Icons.code_rounded,
            iconColor: const Color(0xFF64748B),
            title: 'Built With',
            child: Column(
              children: [
                _TechRow(label: 'Framework', value: 'Flutter / Dart'),
                _TechRow(label: 'Backend & Auth', value: 'Supabase'),
                _TechRow(label: 'State Management', value: 'flutter_bloc'),
                _TechRow(
                    label: 'Architecture', value: 'Clean Architecture (DDD)'),
                _TechRow(label: 'Target Platform', value: 'iOS & Android'),
              ],
            ),
          ),

          const Gap(16),

          // Version info
          _InfoCard(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.foreground,
            title: 'Version Details',
            child: Column(
              children: [
                _TechRow(label: 'App Version', value: _appVersion),
                _TechRow(label: 'Build Number', value: _buildNumber),
                _TechRow(label: 'Released', value: 'April 2026'),
                _TechRow(label: 'School', value: 'University of San Carlos'),
              ],
            ),
          ),

          const Gap(24),

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'Made with ♥ for DCISM students',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.foreground.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Gap(6),
                Text(
                  '© 2026 Tempus. All rights reserved.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.foreground.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Gap(10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const Gap(14),
          child,
        ],
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.text.withValues(alpha: 0.75),
        height: 1.65,
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  final bool isLast;

  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Gap(2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.text.withValues(alpha: 0.65),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechRow extends StatelessWidget {
  final String label;
  final String value;

  const _TechRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}