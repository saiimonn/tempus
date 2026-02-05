import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color brandBlue = const Color(0xFF1A56DB);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE5EAF5),
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
                    className: 'text-white font-bold text-xl tracking-widest',
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
                            color: Colors.black.withValues(alpha: 0.1),
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
                          _label('Student ID *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _idController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: _inputStyle(
                              "Enter your student ID",
                              isFocused: true,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // --- Password ---
                          _label('Password *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _inputStyle("Enter your password"),
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
                                    'text-[#1A56DB] font-bold cursor-pointer text-sm',
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
                                    'text-[#1A56DB] font-bold cursor-pointer text-sm',
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

  // Helper for bold labels
  Widget _label(String text) {
    return RichText(
      text: TextSpan(
        text: text.replaceAll('*', ''),
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        children: [
          if (text.contains('*'))
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  // Input styling
  InputDecoration _inputStyle(String hint, {bool isFocused = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFE0E0E0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: brandBlue, width: 2),
      ),
    );
  }
}
