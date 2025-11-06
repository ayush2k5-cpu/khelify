import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'record_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainAppScreen extends StatefulWidget {
  final String userRole;

  const MainAppScreen({required this.userRole});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userRole: widget.userRole),
      DiscoverScreen(userRole: widget.userRole),
      if (widget.userRole == 'athlete') RecordScreen(),
      ProfileScreen(userRole: widget.userRole),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          if (widget.userRole == 'athlete')
            BottomNavigationBarItem(
              icon: Icon(Icons.videocam),
              label: 'Record',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}