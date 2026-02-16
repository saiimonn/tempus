import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

// --- YOUR IMPORTS ---
import 'package:tempus/core/theme/app_colors.dart';
import '../../../core/widgets/auth_background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // --- STATE ---
  int _currentStep = 1;
  bool _isLoading = false;
  static const String _schoolDomain = "@usc.edu.ph";

  // --- CONTROLLERS ---
  final _fullNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- PASSWORD VALIDATION STATE ---
  bool _isLengthValid = false;
  bool _isComplexityValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIC: Validation ---
  void _validatePassword() {
    final pass = _passwordController.text;
    setState(() {
      _isLengthValid = pass.length >= 8 && pass.length <= 20;

      int criteriaMet = 0;
      if (pass.contains(RegExp(r'[a-zA-Z]'))) criteriaMet++;
      if (pass.contains(RegExp(r'[0-9]'))) criteriaMet++;
      if (pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) criteriaMet++;

      _isComplexityValid = criteriaMet >= 2;
    });
  }

  // --- LOGIC: Sign Up ---
  Future<void> _signUp() async {
    // Basic Empty Checks
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }

    if (!_isLengthValid || !_isComplexityValid) {
      _showError("Please meet the password requirements");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullEmail = "${_idController.text.trim()}$_schoolDomain";

      //Store the extra details in 'data' (raw_user_meta_data)
      //Maps directly to the jsonb column in auth.users table
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: fullEmail,
        password: _passwordController.text,
        data: {
          'full_name': _fullNameController.text.trim(),
          'course': _courseController.text.trim(),
          'year_level': _yearLevelController.text.trim(),
        },
      );

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: WText(
              'Account Created! Please check your email.',
              className: 'text-white',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context); // Go back to Login Page
      }
    } on AuthException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e) {
      if (mounted) _showError('An unexpected error occurred');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WText(message, className: 'text-white'),
        backgroundColor: AppColors.destructive,
      ),
    );
  }

  void _goToStep2() {
    if (_fullNameController.text.isEmpty ||
        _courseController.text.isEmpty ||
        _yearLevelController.text.isEmpty) {
      _showError("Please fill in all details");
      return;
    }
    setState(() => _currentStep = 2);
  }

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 40,
              left: 40,
              right: 40,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER: Logo & Title ---
                IconButton(
                  onPressed: () {
                    if (_currentStep == 2) {
                      setState(() => _currentStep = 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_back, color: AppColors.text),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                const SizedBox(height: 10),

                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 40),
                      const SizedBox(height: 20),
                      WText(
                        "Create your details",
                        className:
                            'text-3xl font-black tracking-tighter text-center',
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Personal Info
  Widget _buildStep1() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Full Name"),
        const SizedBox(height: 8),
        _buildInput(controller: _fullNameController, hint: "e.g. John Doe"),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Course"),
                  const SizedBox(height: 8),
                  _buildInput(controller: _courseController, hint: "e.g. BSCS"),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Year Level"),
                  const SizedBox(height: 8),
                  _buildInput(
                    controller: _yearLevelController,
                    hint: "1",
                    isNumber: true,
                    customFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[1-4]')),
                      LengthLimitingTextInputFormatter(1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        _buildButton(text: "Next", onTap: _goToStep2),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("ID Number"),
        const SizedBox(height: 8),
        _buildInput(
          controller: _idController,
          hint: "Enter your school ID",
          isNumber: true,
        ),

        const SizedBox(height: 16),

        _buildLabel("Password"),
        const SizedBox(height: 8),
        _buildInput(
          controller: _passwordController,
          hint: "Enter your password",
          isPassword: true,
        ),

        const SizedBox(height: 20),

        _buildValidationItem(_isLengthValid, "Use 8 to 20 characters"),
        const SizedBox(height: 6),
        _buildValidationItem(
          _isComplexityValid,
          "Use 2 of the following: letters, numbers, or symbols",
        ),

        const SizedBox(height: 40),

        _buildButton(
          text: "Create Account",
          onTap: _isLoading ? null : _signUp,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildButton({
    required String text,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.brandBlue,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBlue.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : WText(text, className: 'text-base font-bold text-white'),
        ),
      ),
    );
  }

  Widget _buildValidationItem(bool isValid, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? Colors.green : AppColors.foreground,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: WText(
            text,
            className: 'text-xs',
            style: TextStyle(
              color: isValid ? Colors.green : AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return WText(
      text,
      className: 'text-sm font-bold',
      style: const TextStyle(color: AppColors.text),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isNumber = false,
    List<TextInputFormatter>? customFormatters,
  }) {
    List<TextInputFormatter> formatters = customFormatters ?? [];
    if (customFormatters == null && isNumber) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputFill, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: formatters,
        style: const TextStyle(color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.foreground, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
