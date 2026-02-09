import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For digitsOnly formatter
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/home/presentation/home_page.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/required_label.dart';
import 'package:tempus/core/theme/app_input_theme.dart';

import 'register_page.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // --- CONFIGURATION: Your School Domain ---
  static const String _schoolDomain = "@usc.edu.ph";

  @override
  void initState() {
    super.initState();
    // This triggers when the app opens from the email link
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (mounted) {
          // User is verified! Redirect to Home Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
  }

  Future<void> _signIn() async {
    final studentId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (studentId.isEmpty || password.isEmpty) {
      _showError('Please enter Student ID and Password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // User types: "18100760"
      // System sends: "18100760@usc.edu.ph"
      final fullEmail = "$studentId$_schoolDomain";

      // Log in with the constructed email
      final AuthResponse res = await Supabase.instance.client.auth
          .signInWithPassword(email: fullEmail, password: password);

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
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
      SnackBar(content: Text(message), backgroundColor: AppColors.destructive),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              const AppHeader(),

              // ---------------- BODY ----------------
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: WText(
                              'Welcome!',
                              className:
                                  'text-4xl font-extrabold text-black text-center',
                            ),
                          ),

                          // CARD CONTAINER
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.text.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Student ID Input (Numbers Only) ---
                                const RequiredLabel('Student ID *'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _idController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: AppInputTheme.loginInputStyle(
                                    "Enter your student ID",
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // --- Password ---
                                const RequiredLabel('Password *'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: AppInputTheme.loginInputStyle(
                                    "Enter your password",
                                  ),
                                ),

                                // --- Forgot Password ---
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 24,
                                    ),
                                    child: WText(
                                      'Forgot Password?',
                                      className:
                                          'text-[${AppColors.brandBlueHex}] font-bold cursor-pointer text-sm',
                                    ),
                                  ),
                                ),

                                // --- Sign In Button ---
                                GestureDetector(
                                  onTap: _isLoading ? null : _signIn,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isLoading
                                          ? AppColors.foreground
                                          : AppColors.brandBlue,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.brandBlue.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Sign in',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // --- Register Link ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WText(
                                      "Don't have an account? ",
                                      className:
                                          'text-black font-medium text-sm',
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: WText(
                                        "Register here",
                                        className:
                                            'text-[${AppColors.brandBlueHex}] font-bold cursor-pointer text-sm',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ---------------- FOOTER ----------------
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
