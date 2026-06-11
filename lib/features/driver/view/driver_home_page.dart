import 'package:beepbeep_prototype/features/auth/repository/auth_repository.dart';
import 'package:beepbeep_prototype/features/auth/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/driver/viewmodel/driver_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverViewModel(AuthRepository(AuthService())),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Driver Home Page"),
            ElevatedButton(onPressed: () => signOut(), child: Text('Log Out')),
          ],
        ),
      ),
    );
  }
}
