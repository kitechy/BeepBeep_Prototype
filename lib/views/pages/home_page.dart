import 'package:beepbeep_prototype/controller/home_page_controller.dart';
import 'package:beepbeep_prototype/views/pages/bottom_navigation_bar.dart';
import 'package:beepbeep_prototype/views/pages/commuter_screen.dart';
import 'package:beepbeep_prototype/views/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController _controller;

  final List<Widget> _pages = [const CommuterScreen(), const ProfilePage()];

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
  }

  void _onIndexChanged(int index) {
    setState(() {
      _controller.updateSelectedIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_controller.getSelectedIndex()],
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _controller.getSelectedIndex(),
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
