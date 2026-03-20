import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';


class SectionCard extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  const SectionCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
              letterSpacing: 0.3,
            ),
          ),
        ),

        Container(
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
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  items[i],
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      indent: 52,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
 
  const MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 17,
                color: AppColors.brandBlue,
              ),
            ),

            const Gap(12),

            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),

            if (trailing != null) ...[
              trailing!,
              const Gap(4),
            ],

            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.foreground.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}