import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/required_label.dart';
import 'package:tempus/core/theme/app_input_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color brandBlue = AppColors.brandBlue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height, // Forces full screen height
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                color: brandBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: SafeArea(
                  bottom: false,
                  child: WText(
                    'TEMPUS',
                    className: 'text-white font-bold text-2xl tracking-widest',
                  ),
                ),
              ),

              // ---------------- BODY (Center Card) ----------------
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: WText(
                              'Welcome!',
                              className:
                                  'text-3xl font-extrabold text-black mb-8',
                            ),
                          ),

                          // --- Student ID ---
                          RequiredLabel('Student ID *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _idController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: AppInputTheme.loginInputStyle("Enter your student ID",),
                          ),

                          const SizedBox(height: 20),

                          // --- Password ---
                          RequiredLabel('Password *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: AppInputTheme.loginInputStyle("Enter your password"),
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
                            onTap: () => print("Login Clicked"),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: brandBlue,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: brandBlue.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
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
                                className: 'text-black font-medium text-sm',
                              ),
                              WText(
                                "Register here",
                                className:
                                    'text-[${AppColors.brandBlueHex}] font-bold cursor-pointer text-sm',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ---------------- FOOTER ----------------
              Container(
                width: double.infinity,
                color: brandBlue,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const Text(
                      'TEMPUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '© 2026 Mobile Development | Final Project',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Justin Rey, Jemuel Valencia, Simon Gementiza',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
