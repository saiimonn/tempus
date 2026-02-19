import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/onboarding/data/onboarding_service.dart';
import 'package:tempus/features/home/presentation/pages/home_page.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/onboarding/data/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return _buildPage(onboardingPages[index]);
            },
          ),

          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingPages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.brandBlue,
                    dotColor: AppColors.foreground,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                    spacing: 8,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPage == onboardingPages.length - 1
                        ? _buildActionButton("Done", () => _finish(context))
                        : _buildActionButton("Skip", () => _finish(context)),

                    _currentPage == onboardingPages.length - 1
                        ? IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: AppColors.brandBlue,
                              size: 28,
                            ),
                            onPressed: () => _finish(context),
                          )
                        : TextButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutQuart,
                              );
                            },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
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
                  const SizedBox(height: 10),
                  Text(
                    _currentPage == 0 ? "LOGO HERE" : "ICON HERE",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.brandBlue,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
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

                  const SizedBox(height: 15),

                  Text(
                    item.desc,
                    style: TextStyle(fontSize: 16, color: AppColors.foreground),
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
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  void _finish(BuildContext context) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await OnboardingService.markComplete(userId);
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
