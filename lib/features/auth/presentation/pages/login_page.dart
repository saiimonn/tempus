import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:tempus/features/home/presentation/pages/home_page.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'register_page.dart';
import 'package:tempus/core/widgets/auth_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  static const String _schoolDomain = "@usc.edu.ph";

  // --- LOGIC ---
  Future<void> _signIn() async {
    final studentId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (studentId.isEmpty || password.isEmpty) {
      _showError('Please enter Student ID and Password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullEmail = "$studentId$_schoolDomain";
      final AuthResponse res = await Supabase.instance.client.auth
          .signInWithPassword(email: fullEmail, password: password);

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: WText('Login Successful!', className: 'text-white'),
            backgroundColor: Colors.green,
          ),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
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

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedIn && mounted) {
        final userId = data.session?.user.id;
        if (userId == null) return;

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
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
            padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LOGO & TITLE ---
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 50),
                      const SizedBox(height: 24),

                      WText(
                        "Sign in",
                        className: 'text-4xl tracking-tighter',
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- INPUTS ---
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

                const SizedBox(height: 30),

                // --- BUTTON ---
                GestureDetector(
                  onTap: _isLoading ? null : _signIn,
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
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const WText(
                              "Continue",
                              className: 'text-base font-bold text-white',
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- FOOTER ---
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const WText(
                        "No account? ",
                        className: 'text-sm',
                        style: TextStyle(color: AppColors.text),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const WText(
                          "Sign up",
                          className: 'text-sm font-bold',
                          style: TextStyle(color: AppColors.brandBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: WText(
        text,
        className: 'text-sm font-bold',
        style: const TextStyle(color: AppColors.text),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isNumber = false,
  }) {
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
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
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
