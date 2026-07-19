import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';

import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';

import 'package:beepbeep_prototype/features/driver/viewmodel/driver_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverViewModel(
        AuthRepository(AuthService()),
        DriverRepository(DriverService()),
        UserRepository(UserService()),
      ),
      child: _DriverView(),
    );
  }
}

class _DriverView extends StatefulWidget {
  const _DriverView();

  @override
  State<_DriverView> createState() => __DriverViewState();
}

class __DriverViewState extends State<_DriverView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> signOut() async {
    final driverVM = context.read<DriverViewModel>();

    final success = await driverVM.logout();

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            message: "Log out failed. Please try again later.",
          );
        },
      );
    }
  }

  void changeRole() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Driver Home Page"),
            ElevatedButton(onPressed: () => signOut(), child: Text('Log Out')),
            ElevatedButton(
              onPressed: changeRole,
              child: Icon(Icons.swap_horiz_outlined, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
