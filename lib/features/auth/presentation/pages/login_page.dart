import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:tempus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tempus/features/auth/presentation/bloc/auth_event.dart';
import 'package:tempus/features/auth/presentation/bloc/auth_state.dart';
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WText(message, className: 'text-white'),
        backgroundColor: AppColors.destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc.create(),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            _showError(state.errorMessage!);
            context.read<AuthBloc>().add(const AuthStatusResetRequested());
          }

          if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: WText('Login Successful!', className: 'text-white'),
                backgroundColor: Colors.green,
              ),
            );

            context.read<AuthBloc>().add(const AuthStatusResetRequested());

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: AuthBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return _buildInput(
                          controller: _passwordController,
                          hint: "Enter your password",
                          isPassword: !state.isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.foreground,
                              size: 20,
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                const AuthPasswordVisibilityToggled(),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        final isLoading = state.status == AuthStatus.loading;

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  final studentId = _idController.text.trim();
                                  final password = _passwordController.text
                                      .trim();

                                  if (studentId.isEmpty || password.isEmpty) {
                                    _showError(
                                      'Please enter Student ID and Password',
                                    );
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                    AuthSignInRequested(
                                      studentId: studentId,
                                      password: password,
                                    ),
                                  );
                                },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.brandBlue,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandBlue.withValues(
                                    alpha: 0.25,
                                  ),
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
                                  : const WText(
                                      "Continue",
                                      className:
                                          'text-base font-bold text-white',
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
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
        ),
      ),
    );
  }

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

  // Updated helper to include suffixIcon parameter
  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isNumber = false,
    Widget? suffixIcon, // Added this
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
          suffixIcon: suffixIcon, // Added this
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
