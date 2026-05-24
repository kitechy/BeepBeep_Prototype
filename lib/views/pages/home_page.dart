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
  late HomePageController _homePageController;

  final List<Widget> _pages = [const CommuterScreen(), const ProfilePage()];

  @override
  void initState() {
    super.initState();
    _homePageController = HomePageController();
  }

  void _onIndexChanged(int index) {
    _homePageController.selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _homePageController.selectedIndex,
        builder: (context, selectedIndex, child) {
          return _pages[selectedIndex];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _homePageController.selectedIndex,
        builder: (context, selectedIndex, child) {
          return BottomNavigationBarWidget(
            selectedIndex: selectedIndex,
            onIndexChanged: _onIndexChanged,
          );
        },
      ),
    );
  }
}
