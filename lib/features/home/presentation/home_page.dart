import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _signOut() async {
    try {
      // 1. Sign out from Supabase
      await Supabase.instance.client.auth.signOut();

      if (mounted) {
        // 2. Go back to Login Page and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error signing out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current user data (optional, just to show email)
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tempus Home"),
        backgroundColor: AppColors.brandBlue,
        foregroundColor: Colors.white,
        actions: [
          // --- LOGOUT BUTTON ---
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80, color: AppColors.brandBlue),
            const SizedBox(height: 20),
            WText("Welcome Back!", className: 'text-2xl font-bold text-black'),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
