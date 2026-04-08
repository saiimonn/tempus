import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static const String _effectiveDate = 'April 8, 2026';

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
          'Privacy Policy',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.brandBlue.withValues(alpha: 0.15),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.brandBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColors.brandBlue,
                        size: 22,
                      ),
                    ),

                    const Gap(12),

                    const Expanded(
                      child: Text(
                        'Your privacy matters to us.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brandBlue,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(12),

                Text(
                  'This policy explains how Tempus collects, uses, and protects your personal data. Please read it carefully.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.text.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),

                const Gap(8),

                Text(
                  'Effective Date: $_effectiveDate',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),
          
          const _PolicySection(
                      number: '1',
                      title: 'Information We Collect',
                      content: [
                        _PolicyParagraph(
                          text:
                              'When you create a Tempus account, we collect your full name, USC student ID number, course, and year level. Your account email is derived from your student ID using the USC school domain.',
                        ),
                        _PolicyParagraph(
                          heading: 'Data you create:',
                          text:
                              'All tasks, schedule entries, financial transactions, subscriptions, subjects, grade categories, and scores you add within the app are stored securely in our database and associated with your account.',
                        ),
                        _PolicyParagraph(
                          heading: 'Device and usage data:',
                          text:
                              'We may collect basic technical information such as device type and operating system version to improve app performance and fix bugs. We do not collect precise location data.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '2',
                      title: 'How We Use Your Information',
                      content: [
                        _PolicyParagraph(
                          text:
                              'We use your information solely to provide and improve the Tempus experience. Specifically, we use your data to:',
                        ),
                        _PolicyBulletList(items: [
                          'Authenticate your account and keep your session secure.',
                          'Store and sync your tasks, schedule, finances, and academic data across devices.',
                          'Display personalized summaries on your home screen.',
                          'Improve app stability and performance based on anonymized usage patterns.',
                        ]),
                        _PolicyParagraph(
                          text:
                              'We do not use your personal data for advertising, and we do not sell or rent your information to any third party.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '3',
                      title: 'Data Storage and Security',
                      content: [
                        _PolicyParagraph(
                          text:
                              'Your data is stored using Supabase, a secure cloud database platform with industry-standard encryption in transit (TLS) and at rest. Access to your data is controlled through row-level security policies, meaning only you can access your personal records.',
                        ),
                        _PolicyParagraph(
                          text:
                              'We take reasonable technical and organizational measures to protect your information from unauthorized access, alteration, or disclosure. However, no method of transmission over the Internet is 100% secure.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '4',
                      title: 'Data Retention',
                      content: [
                        _PolicyParagraph(
                          text:
                              'We retain your account and app data for as long as your account is active. Deleted items (tasks, transactions, schedule entries) are soft-deleted and may be retained temporarily before permanent removal.',
                        ),
                        _PolicyParagraph(
                          text:
                              'If you wish to have your account and all associated data permanently deleted, please contact us at the address listed in Section 7.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '5',
                      title: 'Third-Party Services',
                      content: [
                        _PolicyParagraph(
                          text:
                              'Tempus uses the following third-party services to operate:',
                        ),
                        _PolicyBulletList(items: [
                          'Supabase — for database, authentication, and storage.',
                          'Flutter / Dart — the open-source framework powering the app.',
                        ]),
                        _PolicyParagraph(
                          text:
                              'These services have their own privacy policies. We encourage you to review them. We do not share your data with any other third parties beyond what is necessary for app functionality.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '6',
                      title: 'Your Rights',
                      content: [
                        _PolicyParagraph(
                          text:
                              'You have the right to access, correct, or delete your personal data at any time. Within the app, you can update your profile information (name, course, year level) directly from the Profile page.',
                        ),
                        _PolicyParagraph(
                          text:
                              'For requests that cannot be fulfilled within the app — such as full account deletion or data export — please contact us using the information in Section 7.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '7',
                      title: 'Contact Us',
                      content: [
                        _PolicyParagraph(
                          text:
                              'If you have questions, concerns, or requests related to this Privacy Policy or your personal data, please reach out to the Tempus development team:',
                        ),
                        _PolicyParagraph(
                          heading: 'Email:',
                          text: 'support@tempus-app.dev',
                        ),
                        _PolicyParagraph(
                          text:
                              'We will do our best to respond to your inquiry within 7 business days.',
                        ),
                      ],
                    ),
           
                    const _PolicySection(
                      number: '8',
                      title: 'Changes to This Policy',
                      content: [
                        _PolicyParagraph(
                          text:
                              'We may update this Privacy Policy from time to time. When we do, we will revise the Effective Date at the top of this page. Continued use of the app after any changes constitutes your acceptance of the updated policy.',
                        ),
                      ],
                      isLast: true,
                    ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String number;
  final String title;
  final List<Widget> content;
  final bool isLast;

  const _PolicySection({
    required this.number,
    required this.title,
    required this.content,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue,
                    borderRadius: BorderRadius.circular(7),
                  ),

                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const Gap(10),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),

            const Gap(14),
            ...content,
          ],
        ),
      ),
    );
  }
}

class _PolicyParagraph extends StatelessWidget {
  final String? heading;
  final String text;

  const _PolicyParagraph({this.heading, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          children: [
            if (heading != null)
              TextSpan(
                text: '$heading',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  height: 1.6,
                ),
              ),

            TextSpan(
              text: text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.text.withValues(alpha: 0.75),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyBulletList extends StatelessWidget {
  final List<String> items;

  const _PolicyBulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.brandBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.text.withValues(alpha: 0.75),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
