import 'package:beepbeep_prototype/features/auth/repository/auth_repository.dart';
import 'package:beepbeep_prototype/features/auth/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/operator/viewmodel/operator_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperatorHomePage extends StatelessWidget {
  const OperatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OperatorViewModel(AuthRepository(AuthService())),
      child: _OperatorView(),
    );
  }
}

class _OperatorView extends StatefulWidget {
  const _OperatorView();

  @override
  State<_OperatorView> createState() => __OperatorViewState();
}

class __OperatorViewState extends State<_OperatorView> {
  Future<void> signOut() async {
    final driverVM = context.read<OperatorViewModel>();

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
            Text("Operator Home Page"),
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
