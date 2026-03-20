import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:tempus/features/profile/presentation/widgets/info_card.dart';
import 'package:tempus/features/profile/presentation/widgets/profile_header.dart';
import 'package:tempus/features/profile/presentation/widgets/section_card.dart';
import 'package:tempus/features/profile/presentation/widgets/sign_out_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.signedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        if (state.status == ProfileStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.destructive,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },

      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: switch(state.status) {
              ProfileStatus.initial || ProfileStatus.loading => 
                const _ProfileSkeleton(),
              ProfileStatus.error => _ErrorContent(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () => context
                    .read<ProfileBloc>()
                    .add(const ProfileLoadRequested()),
              ),
              _ => state.profile == null
                ? const _ProfileSkeleton()
                : _ProfileContent(profile: state.profile!),
            },
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileContent({required this.profile});

  @override 
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ProfileHeader(profile: profile)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              InfoCard(profile: profile),
              const Gap(16),

              SectionCard(
                title: 'App',
                items: [
                  MenuItem(
                    icon: Icons.color_lens_outlined,
                    label: 'Appearance',
                    onTap: () {},
                  ),
                ],
              ),
              const Gap(16),
              SectionCard(
                title: 'Support',
                items: [
                  MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & FAQ',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Tempus',
                    trailing: const Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.foreground,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const Gap(16),
              SignOutButton(),
              const Gap(8),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 280,
          decoration: const BoxDecoration(
            color: AppColors.brandBlue,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),

          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SkeletonBox(width: double.infinity, height: 160, radius: 16),
                const Gap(16),
                _SkeletonBox(width: double.infinity, height: 120, radius: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.destructive.withValues(alpha: 0.5),
            ),

            const Gap(16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.destructive,
                fontSize: 16,
              ),
            ),

            const Gap(24),

            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}