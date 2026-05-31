import 'package:flutter/material.dart';

import '../home/presentation/home_screen.dart';
import '../history/presentation/history_screen.dart';
import '../profile/presentation/profile_screen.dart';
import '../../core/localization/app_localizations.dart';

/// MainNavigationHub - Pages 43-45: Core App Architecture
/// Standard BottomNavigationBar managing state of 3 primary tabs:
/// Tab 1: HomeScreen (search cockpit)
/// Tab 2: HistoryScreen (trip history)
/// Tab 3: ProfileScreen (user profile)
class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0F4C81),
          unselectedItemColor: Colors.grey[400],
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined, size: 26),
              activeIcon: const Icon(Icons.home_filled, size: 26),
              label: localization.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_outlined, size: 26),
              activeIcon: const Icon(Icons.history, size: 26),
              label: localization.translate('history'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline, size: 26),
              activeIcon: const Icon(Icons.person, size: 26),
              label: localization.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
