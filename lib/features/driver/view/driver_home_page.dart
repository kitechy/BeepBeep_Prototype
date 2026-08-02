import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/features/driver/view/widgets/status_indicator.dart';
import 'package:beepbeep_prototype/features/driver/viewmodel/driver_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:beepbeep_prototype/shared/widgets/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/models/app.user.role.dart';
import 'package:beepbeep_prototype/shared/widgets/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:beepbeep_prototype/features/about/view/about_page.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverViewModel(
        AuthRepository(AuthService()),
        DriverRepository(DriverService()),
        MapService(),
        RoutesRepository(RoutesService()),
        LocationService(),
        MarkerService(),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final driverVM = context.read<DriverViewModel>();

      await driverVM.loadRoutes();
      await driverVM.loadDriverProfile();
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
        key: _scaffoldKey,

        drawer: DrawerComponent(
          role: AppUserRole.driver,
          onHomeTap: () {},
          onPlaceholderTap: () {
            debugPrint('Placeholder');
          },
          onAboutTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AboutPage()),
        ),
          onLogOutTap: signOut,
        ),

        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.1391, 123.7438),
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              onMapCreated: driverVM.onMapCreated,
              polylines: driverVM.polylines,
              markers: driverVM.markers,
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

            Positioned(
              top: 55,
              left: 16,
              right: 16,
              child: SafeArea(
                child: StatusIndicator(
                  isOnline: driverVM.isOnline,
                  greeting: driverVM.greeting,
                  driverName: driverVM.driverName,
                ),
              ),
            ),

            Positioned(
              bottom: 50 + 52 + 16,
              right: 25,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "routes",
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.route_rounded,
                      color: Color(0xff0057FF),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => RouteBottomSheet(
                          routes: driverVM.availableRoutes,
                          onRouteSelected: (routes) async {
                            await driverVM.selectRoute(routes);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Positioned(
              left: 25,
              right: 25,
              bottom: 50,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: driverVM.isOnline
                        ? Color(0xff808080)
                        : Color(0xff0056FF),
                    foregroundColor: driverVM.isOnline
                        ? Color(0xffff0000)
                        : Color(0xffFFFFFF),
                  ),
                  onPressed: driverVM.toggleStatus,
                  child: Text(
                    driverVM.isOnline
                        ? 'Stop sharing live location'
                        : 'Start sharing live location',
                    style: TextStyle(
                      fontSize: 13.5,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
