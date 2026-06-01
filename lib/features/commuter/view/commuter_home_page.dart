import 'package:beepbeep_prototype/features/profile/view/profile_page.dart';
import 'package:beepbeep_prototype/features/commuter/view/tracking_page.dart';
import 'package:beepbeep_prototype/features/commuter/view/widgets/bottom_navigation_bar.dart';
import 'package:beepbeep_prototype/features/commuter/viewmodel/commuter_home_page_viewmodel.dart';
import 'package:flutter/material.dart';

class CommuterHomePage extends StatefulWidget {
  const CommuterHomePage({super.key});

  @override
  State<CommuterHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<CommuterHomePage> {
  late CommuterHomePageController _homePageController;

  final List<Widget> _pages = [const TrackingPage(), const ProfilePage()];

  @override
  void initState() {
    super.initState();
    _homePageController = CommuterHomePageController();
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
