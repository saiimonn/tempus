import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIdx;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIdx,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIdx,
      onTap: onTap,
      selectedItemColor: AppColors.brandBlue,
      unselectedItemColor: AppColors.foreground,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.note_rounded), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet_rounded), label: 'Finances'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books_rounded), label: 'Subjects'),
      ]
    );
  }
}