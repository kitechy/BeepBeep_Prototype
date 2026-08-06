import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/about/view/about_page.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';
import 'package:beepbeep_prototype/features/operator/view/widgets/status_bar_widget.dart';
import 'package:beepbeep_prototype/features/operator/viewmodel/operator_viewmodel.dart';
import 'package:beepbeep_prototype/shared/widgets/compass_widget.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:beepbeep_prototype/shared/components/drawer/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OperatorHomePage extends StatelessWidget {
  const OperatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OperatorViewModel(
        AuthRepository(AuthService()),
        UserRepository(UserService()),
        OperatorRepository(OperatorService()),
        DriverRepository(DriverService()),
        MapService(),
      ),
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final operatorVM = context.read<OperatorViewModel>();

      await operatorVM.loadCurrentUser();
      await operatorVM.loadOperatorProfile();
      operatorVM.loadDrivers(operatorVM.operatorUid);
    });
  }

  Future<void> signOut() async {
    final operatorVM = context.read<OperatorViewModel>();
    final success = await operatorVM.logout();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          message: 'Log out failed. Please try again later.',
        ),
      );
    }
  }

  void navigateToAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final operatorVM = context.watch<OperatorViewModel>();
    return Scaffold(
      key: _scaffoldKey,

      drawer: DrawerComponent(
        currentUser: operatorVM.operatorName,
        role: operatorVM.role,
        photoURL: operatorVM.photoUrl,
        onHomeTap: () {},
        onPlaceholderTap: () {},
        onAboutTap: navigateToAboutPage,
        onLogOutTap: signOut,
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.1391, 123.7438),
              zoom: 15,
            ),
            compassEnabled: false,
            onCameraMove: operatorVM.onCameraMove,
            zoomControlsEnabled: false,
            onMapCreated: operatorVM.onMapCreated,
          ),

          Consumer<OperatorViewModel>(
            builder: (context, operatorVM, child) {
              return Positioned(
                top: 55,
                left: 16,
                right: 16,
                child: SafeArea(
                  child: StatusBarWidget(
                    fleetCount: operatorVM.fleetCount,
                    onlineD: operatorVM.onlineCount,
                    offlineD: operatorVM.offlineCount,
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 140,
            right: 16,
            child: CompassWidget(
              bearingStream: operatorVM.bearingStream,
              initialBearing: operatorVM.currentBearing,
              onTap: operatorVM.resetBearing,
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
