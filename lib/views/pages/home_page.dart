import 'package:beepbeep_prototype/controller/bottom_navigation_bar.dart';
import 'package:beepbeep_prototype/views/pages/tracking_page.dart';
import 'package:beepbeep_prototype/views/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TrackingPage(),
    const ProfilePage(),
  ];

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
