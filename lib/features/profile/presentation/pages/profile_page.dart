import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _courseController;
  late final TextEditingController _yearLevelController;

  bool _controllersInitialized = false;

  void _initControllers(ProfileEntity profile) {
    if (_controllersInitialized) return;
    _fullNameController = TextEditingController(text: profile.fullName);
    _courseController = TextEditingController(text: profile.course);
    _yearLevelController = TextEditingController(text: profile.yearLevel);
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      _fullNameController.dispose();
      _courseController.dispose();
      _yearLevelController.dispose();
    }
    super.dispose();
  }

  void _enterEditMode(ProfileEntity profile) {
    _fullNameController.text = profile.fullName;
    _courseController.text = profile.course;
    _yearLevelController.text = profile.yearLevel;
    setState(() => _isEditing = true);
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
  }

  void _saveChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        fullName: _fullNameController.text.trim(),
        course: _courseController.text.trim(),
        yearLevel: _yearLevelController.text.trim(),
      ),
    );

    setState(() => _isEditing = false);
  }

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

        if (state.status == ProfileStatus.updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  Gap(8),
                  Text(
                    'Profile updated!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
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
          final isLoading =
              state.status == ProfileStatus.initial ||
              state.status == ProfileStatus.loading;

          if (isLoading || state.profile == null) {
            return const _ProfileSkeleton();
          }

          if (state.status == ProfileStatus.error) {
            return _ErrorContent(
              message: state.errorMessage ?? 'Something went wrong',
              onRetry: () => context
                  .read<ProfileBloc>()
                  .add(const ProfileLoadRequested()),
            );
          }

          final profile = state.profile!;
          _initControllers(profile);

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.brandBlue,
              elevation: 0,
              leading: _isEditing
                  ? IconButton(
                      icon: const Icon(Icons.close, color: AppColors.background),
                      onPressed: _cancelEdit,
                    )
                  : IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.background),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
              title: _isEditing
                  ? const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    )
                  : null,
              actions: [
                if (_isEditing)
                  TextButton(
                    onPressed: () => _saveChanges(context),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: () => _enterEditMode(profile),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.background,
                    ),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _isEditing
                  ? _EditContent(
                      key: const ValueKey('edit'),
                      profile: profile,
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      courseController: _courseController,
                      yearLevelController: _yearLevelController,
                      onSave: () => _saveChanges(context),
                      isUpdating: state.status == ProfileStatus.updating,
                    )
                  : _ViewContent(
                      key: const ValueKey('view'),
                      profile: profile,
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _ViewContent extends StatelessWidget {
  final ProfileEntity profile;

  const _ViewContent({super.key, required this.profile});

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
                      style: TextStyle(fontSize: 13, color: AppColors.foreground),
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

// ─── Edit ─────────────────────────────────────────────────────────────────────

class _EditContent extends StatelessWidget {
  final ProfileEntity profile;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController courseController;
  final TextEditingController yearLevelController;
  final VoidCallback onSave;
  final bool isUpdating;

  const _EditContent({
    super.key,
    required this.profile,
    required this.formKey,
    required this.fullNameController,
    required this.courseController,
    required this.yearLevelController,
    required this.onSave,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // Avatar
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandBlue.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.brandBlue.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandBlue,
                  ),
                ),
              ),
            ),
          ),

          const Gap(28),

          _SectionHeader(label: 'Personal Info'),
          const Gap(12),

          _EditCard(
            child: Column(
              children: [
                _EditField(
                  label: 'Full Name',
                  controller: fullNameController,
                  hint: 'e.g. Juan dela Cruz',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                _FieldDivider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _EditField(
                        label: 'Course',
                        controller: courseController,
                        hint: 'e.g. BSCS',
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: _EditField(
                        label: 'Year',
                        controller: yearLevelController,
                        hint: '1',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[1-4]')),
                          LengthLimitingTextInputFormatter(1),
                        ],
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        isLast: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Gap(20),

          _SectionHeader(label: 'Account'),
          const Gap(12),

          _EditCard(
            child: Column(
              children: [
                _ReadOnlyField(label: 'Student ID', value: profile.studentId),
                _FieldDivider(),
                _ReadOnlyField(
                  label: 'Email',
                  value: profile.email,
                  isLast: true,
                ),
              ],
            ),
          ),

          const Gap(6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Student ID and email cannot be changed.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.foreground.withValues(alpha: 0.7),
              ),
            ),
          ),

          const Gap(32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isUpdating ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared edit sub-widgets ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.foreground,
          letterSpacing: 0.3,
        ),
      );
}

class _EditCard extends StatelessWidget {
  final Widget child;
  const _EditCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
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
        child: child,
      );
}

class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.shade100,
        indent: 16,
        endIndent: 16,
      );
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 56,
        color: Colors.grey.shade100,
      );
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool isLast;

  const _EditField({
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
                letterSpacing: 0.3,
              ),
            ),
            TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              textCapitalization: textCapitalization,
              textInputAction: textInputAction,
              autofocus: autofocus,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ],
        ),
      );
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
                letterSpacing: 0.3,
              ),
            ),
            const Gap(2),
            Text(
              value.isNotEmpty ? value : '—',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
}

// ─── Skeleton / Error ─────────────────────────────────────────────────────────

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              color: AppColors.brandBlue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SkeletonBox(width: 80, height: 80, radius: 40),
                    const Gap(16),
                    _SkeletonBox(width: 160, height: 20, radius: 4),
                    const Gap(8),
                    _SkeletonBox(width: 120, height: 14, radius: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
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
      ),
    );
  }
}