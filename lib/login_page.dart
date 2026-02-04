import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for the number-only field

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Controllers to retrieve text later
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  // The main blue color used in the header, button, and footer
  final Color brandBlue = const Color(0xFF1A56DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5EAF5), // Light blue-grey background
      body: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            color: brandBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TEMPUS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text(
                  //     "FAQs",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // ---------------- BODY (Login Card) ----------------
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 400, // Limits width on larger screens (web/tablet)
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- Student ID Field ---
                      _buildLabel("Student ID *"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _idController,
                        keyboardType:
                            TextInputType.number, // <--- Opens number pad
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // <--- Blocks letters/symbols
                        ],
                        decoration: _inputDecoration("Enter your student ID"),
                      ),
                      const SizedBox(height: 20),

                      // --- Password Field ---
                      _buildLabel("Password *"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration("Enter your password"),
                      ),
                      const SizedBox(height: 10),

                      // --- Forgot Password Link ---
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Add forgot password logic here
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: brandBlue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Sign In Button ---
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            print("ID: ${_idController.text}");
                            print("Pass: ${_passwordController.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- Register Link ---
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                // Add register navigation here
                              },
                              child: Text(
                                "Register here",
                                style: TextStyle(
                                  color: brandBlue,
                                  fontWeight: FontWeight.bold,
                                ),
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

          // ---------------- FOOTER ----------------
          Container(
            width: double.infinity,
            color: brandBlue,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: const [
                Text(
                  "TEMPUS", // Placeholder for Logo
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "© 2026 Mobile Development | Final Project",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  "Justin Rey, Jemuel Valencia, Simon Gementiza",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text.replaceAll('*', ''),
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 14,
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

  // Helper method for Input Styling
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      filled: true,
      fillColor: const Color(0xFFF5F5F5), // Very light grey inside input
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.grey,
        ), // Grey border when idle
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: brandBlue, width: 2), // Blue when clicked
      ),
    );
  }
}
