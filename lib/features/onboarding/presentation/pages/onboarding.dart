import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/onboarding/data/models/onboarding_item_model.dart';
import 'package:tempus/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:tempus/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:tempus/features/onboarding/presentation/widgets/onboarding_page_slide.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<Onboarding> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if(state.isComplete) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final isLastPage = 
            state.currentPage == onboardingItems.length - 1;

          return Scaffold(
            body: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingItems.length,
                  onPageChanged: (index) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingPageChanged(index)),
                  itemBuilder: (_, index) => OnboardingPageSlide(
                    currentPage: state.currentPage,
                    item: onboardingItems[index],
                  ),
                ),

                Positioned(
                  bottom: 40,
                  left: 30,
                  right: 30,
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: onboardingItems.length,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: AppColors.brandBlue,
                          dotColor: AppColors.foreground,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                          spacing: 8,
                        ),
                      ),

                      const Gap(30),

                      OnboardingFooter(
                        isLastPage: isLastPage,
                        onSkipOrDone: () => context
                          .read<OnboardingBloc>()
                          .add(OnboardingComplete()),
                        onNext: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutQuart,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}