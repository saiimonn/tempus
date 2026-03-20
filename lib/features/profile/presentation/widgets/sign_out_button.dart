import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/profile/presentation/bloc/profile_bloc.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final isSigningOut = state.status == ProfileStatus.signingOut;

        return GestureDetector(
          onTap: isSigningOut
            ? null
            : () => context
                .read<ProfileBloc>()
                .add(const ProfileSignOutRequested()),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.destructive.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Center(
              child: isSigningOut
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.destructive,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: AppColors.destructive,
                  ),
                  
                  const Gap(8),

                  const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.destructive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}