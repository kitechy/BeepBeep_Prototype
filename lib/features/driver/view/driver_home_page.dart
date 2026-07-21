import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/features/driver/view/widgets/status_indicator.dart';
import 'package:beepbeep_prototype/features/driver/viewmodel/driver_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverViewModel(
        AuthRepository(AuthService()),
        DriverRepository(DriverService()),
        MapService(),
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

class __DriverViewState extends State<_DriverView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DriverViewModel>().loadDriverProfile();
    });
  }

  @override
  void dispose() {
    _c.dispose();
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
    final driverVM = context.watch<DriverViewModel>();
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: driverVM.isLoading
                  ? Color(0xff2E7D5B)
                  : Colors.transparent,
            ),
          ),
          child: child,
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.1391, 123.7438),
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              onMapCreated: driverVM.onMapCreated,
            ),

            Positioned(
              top: 50,
              left: 20,
              child: StatusIndicator(
                isOnline: driverVM.isOnline,
                onPressed: driverVM.toggleStatus,
                c: _c,
              ),
            ),

            Positioned(
              bottom: 50,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "routes",
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.route_rounded,
                      color: Color(0xff0057FF),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            IgnorePointer(
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, __) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: driverVM.isOnline
                            ? const Color(0xff2E7D5B)
                            : Colors.transparent,
                        width: driverVM.isOnline ? 3 + (_c.value * 2) : 0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
