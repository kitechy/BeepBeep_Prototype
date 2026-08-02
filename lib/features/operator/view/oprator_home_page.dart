import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/operator/viewmodel/operator_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beepbeep_prototype/shared/widgets/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/models/app.user.role.dart';
import 'package:beepbeep_prototype/shared/widgets/drawer_component.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final operatorVM = context.watch<OperatorViewModel>();

    return Scaffold(
      key: _scaffoldKey,

      drawer: DrawerComponent(
        role: AppUserRole.operator,
        onHomeTap: () {},
        onPlaceholderTap: () {
          debugPrint('Routes');
        },
        onPlaceholder2Tap: () {
          debugPrint('Settings');
        },
        onLogOutTap: signOut,
      ),

      body: Stack(
        children: [
          const Center(child: Text('Operator Page')),
          Center(
            child: ElevatedButton.icon(
              onPressed: changeRole,
              icon: const Icon(Icons.swap_horiz_outlined),
              label: const Text('Change Role'),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: const Color(0xffF8F7F4),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _scaffoldKey.currentState!.openDrawer(),
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.menu_rounded,
                          size: 22,
                          color: Color(0xff1C1A17),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
