import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/shared/widgets/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/features/commuter/viewmodel/commuter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:beepbeep_prototype/models/app.user.role.dart';
import 'package:beepbeep_prototype/shared/widgets/drawer_component.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';

class CommuterHomePage extends StatelessWidget {
  const CommuterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommuterViewModel(
        AuthRepository(AuthService()),
        RoutesRepository(RoutesService()),
        DriverRepository(DriverService()),
        MapService(),
        LocationService(),
        MarkerService(),
      ),
      child: const _CommuterView(),
    );
  }
}

class _CommuterView extends StatefulWidget {
  const _CommuterView();

  @override
  State<_CommuterView> createState() => __CommuterViewState();
}

class __CommuterViewState extends State<_CommuterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Future<void> signOut() async {
  final commuterVM = context.read<CommuterViewModel>();
  final success = await commuterVM.logout();

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
        message: 'Log out failed',
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final commuterVM = context.watch<CommuterViewModel>();

    return Scaffold(
      key: _scaffoldKey,

      drawer: DrawerComponent(
        role: AppUserRole.commuter,
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
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.1391, 123.7438),
              zoom: 15,
            ),
            polylines: commuterVM.polylines,
            zoomControlsEnabled: false,
            markers: commuterVM.markers,
            onMapCreated: commuterVM.onMapCreated,
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
                    color: const Color(0xffFFFFFF),
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

          Positioned(
            bottom: 50,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "routes",
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.alt_route, color: Color(0xff0000FF)),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => RouteBottomSheet(
                        routes: commuterVM.availableRoutes,
                        onRouteSelected: (route) async {
                          await commuterVM.loadRoute(route.id);
                        },
                        activeDriverCount: commuterVM.getActiveDriverCount,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Color(0xffFFFFFF),
                  onPressed: commuterVM.initializeTracking,
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xff0000FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
