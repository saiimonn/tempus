import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tempus/features/onboarding/logic/onboarding_bloc.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/onboarding/data/onboarding_model.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if(state.isComplete) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    onPageChanged: (index) => 
                      context.read<OnboardingBloc>().add(PageChanged(index)),
                    itemCount: onboardingPages.length,
                    itemBuilder: (context, index) => 
                      _buildPage(state.currentPage, onboardingPages[index]),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 30,
                    right: 30,
                    child: Column(
                      children: [
                        SmoothPageIndicator(
                          controller: controller,
                          count: onboardingPages.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: AppColors.brandBlue,
                            dotColor: AppColors.foreground,
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 4,
                            spacing: 8,
                          ),
                        ),

                        Gap(30),
                        _buildFooter(context, state, controller),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    OnboardingState state,
    PageController controller,
  ) {
    final isLastPage = state.currentPage == onboardingPages.length - 1;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          isLastPage ? "Done" : "Skip",
          () => context.read<OnboardingBloc>().add(CompleteOnboarding()),
        ),

        if(isLastPage) 
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.brandBlue,
              size: 28,
            ),
            onPressed: () =>
              context.read<OnboardingBloc>().add(CompleteOnboarding()),
          )
        else
          TextButton(
            onPressed: () => controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuart,
            ),
            child: Row(
              children: const [
                Text(
                  "Next",
                  style: TextStyle(
                    color: AppColors.brandBlue,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.brandBlue,
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPage(int currentPage, OnboardingItem item) {

    final List<IconData> pageIcons = [
      Icons.auto_awesome,
      Icons.task_alt,
      Icons.calendar_today,
      Icons.account_balance_wallet,
      Icons.calculate,
    ];

    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
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
                  Gap(10),

                  currentPage == 0
                    ? Image.asset(
                      'assets/images/tempuslogo.png',
                      height: 120,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.timer,
                        color: AppColors.brandBlue,
                        size: 100,
                      ),
                    )
                    : Icon(
                      pageIcons[currentPage],
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

                  Gap(15),

                  Text(
                    item.desc,
                    style: const TextStyle(
                      fontSize: 16,
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

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFADC4F3),
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}