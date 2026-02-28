import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/onboarding/domain/entities/onboarding_item_entity.dart';

class OnboardingPageSlide extends StatelessWidget {
  final int currentPage;
  final OnboardingItemEntity item;

  static const List<IconData> _pageIcons = [
    Icons.auto_awesome,
    Icons.task_alt,
    Icons.calendar_today,
    Icons.account_balance_wallet,
    Icons.calculate,
  ];

  const OnboardingPageSlide({
    super.key,
    required this.currentPage,
    required this.item,
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(10),
                  currentPage == 0
                    ? Image.asset(
                      'assets/images/tempuslogo.png',
                      height: 120,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.timer,
                        color: AppColors.brandBlue,
                        size: 100,
                      ),
                    )
                    : Icon(
                      _pageIcons[currentPage],
                      color: AppColors.brandBlue,
                      size: 100,
                    ),
                ],
              ),
            ),
          ),

          const Divider(indent: 40, endIndent: 40, thickness: 1),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Gap(15),

                  Text(
                    item.desc,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}