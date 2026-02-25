import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:intl/intl.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/core/widgets/bottom_navigation_bar.dart';
import 'package:tempus/features/home/presentation/widgets/empty_task_card.dart';
import 'package:tempus/features/home/presentation/widgets/empty_budget_card.dart';
import 'package:tempus/features/home/presentation/widgets/empty_schedule_card.dart';
import 'package:tempus/features/subjects/presentation/pages/subjects_page.dart';
import 'package:tempus/features/schedule/presentation/pages/schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
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
            backgroundColor: AppColors.destructive,
          ),
        );
      }
    }
  }

  void _onItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String? ?? 'User';
    final String name = fullName.split(' ').first;
    // final nameSplit = user?.userMetadata?['full_name'].split(' ');
    // final String name = nameSplit[0];
    final DateTime now = DateTime.now();
    final date = DateFormat.yMMMMd('en_US').format(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "TEMPUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 24,
              ),
            ),

            Text(
              date,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(name),

          // PLACEHOLDERS FOR PAGES
          const SchedulePage(),
          const Center(child: Text("Tasks Page")),
          const Center(child: Text("Finances Page")),
          SubjectsPage(),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIdx: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent(String firstName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          WText("Welcome, $firstName", className: "text-2xl font-bold mb-4"),

          EmptyTaskCard(),
          const SizedBox(height: 20),

          EmptyBudgetCard(),
          const SizedBox(height: 20),

          EmptyScheduleCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
