import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';

import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/features/driver/view/widgets/scanner_page.dart';
import 'package:beepbeep_prototype/features/driver/view/widgets/status_indicator.dart';
import 'package:beepbeep_prototype/features/driver/viewmodel/driver_viewmodel.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';
import 'package:beepbeep_prototype/shared/components/passenger_count_bottom_sheet/passenger_count_bottom_sheet.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:beepbeep_prototype/shared/components/route_bottom_sheet/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/shared/components/drawer/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:beepbeep_prototype/features/about/view/about_page.dart';
import 'package:beepbeep_prototype/shared/widgets/compass_widget.dart';
import 'package:beepbeep_prototype/features/profile/view/profile_page.dart';
import 'package:beepbeep_prototype/features/settings/view/settings_page.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DriverViewModel(
        AuthRepository(AuthService()),
        UserRepository(UserService()),
        DriverRepository(DriverService()),
        RoutesRepository(RoutesService()),
        OperatorRepository(OperatorService()),
        MapService(),
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
      await driverVM.loadCurrentUser();
      await driverVM.loadDriverProfile();
      await driverVM.loadRoutes();
      await driverVM.startListeningToMyLocation();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationServicesPrompt();
    });
  }

  Future<void> _showLocationServicesPrompt() async {
    if (!mounted || await Geolocator.isLocationServiceEnabled()) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Turn on location services'),
        content: const Text(
          'Please enable location services for live driver tracking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not now'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            icon: const Icon(Icons.location_on),
            label: const Text('Open settings'),
          ),
        ],
      ),
    );
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

  Future<void> scanQrCode(String code) async {
    final driverVM = context.read<DriverViewModel>();
    final success = await driverVM.connectToOperator(code);

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 42,
                    color: Colors.green.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Operator Connected!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  'You have successfully connected to the operator.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0056FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void navigateToAboutPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutPage()),
    );
  }

  void navigateToProfilePage() {
    final driverVM = context.read<DriverViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          name: driverVM.driverName,
          email: driverVM.email,
          photoURL: driverVM.photoUrl,
          role: driverVM.role,
        ),
      ),
    );
  }

  void navigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
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
          currentUser: driverVM.driverName,
          role: driverVM.role,
          photoURL: driverVM.photoUrl,
          onProfileTap: navigateToProfilePage,
          onSettingsTap: navigateToSettingsPage,
          onAboutTap: navigateToAboutPage,
          onLogOutTap: signOut,
          isGuest: false,
        ),

        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.1391, 123.7438),
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              compassEnabled: false,
              onCameraMove: driverVM.onCameraMove,
              onMapCreated: driverVM.onMapCreated,
              polylines: driverVM.polylines,
              markers: driverVM.markers,
              mapToolbarEnabled: false,
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
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: const Color(0xffF8F7F4),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        onTap: () async {
                          final code = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScanOperatorQrPage(),
                            ),
                          );

                          if (!mounted || code == null) return;

                          await scanQrCode(code);
                        },
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
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
                  route: driverVM.currentRouteName,
                  isOnline: driverVM.isOnline,
                  greeting: driverVM.greeting,
                  driverName: driverVM.driverName,
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 130,
              right: 16,
              child: CompassWidget(
                bearingStream: driverVM.bearingStream,
                initialBearing: driverVM.currentBearing,
                onTap: driverVM.resetBearing,
              ),
            ),

            Positioned(
              bottom: 50 + 52 + 16,
              right: 25,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'passengers',
                    backgroundColor: Colors.white,
                    onPressed: () {
                      final profile = driverVM.driverProfile;

                      if (profile == null) {
                        return;
                      }

                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return PassengerCountBottomSheet(
                            occupiedSeats: profile.occupiedSeats,
                            totalSeats: profile.totalSeats,
                            onUpdate: driverVM.updateOccupiedSeats,
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: Color(0xff0057FF),
                    ),
                  ),
                  const SizedBox(height: 12),

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
                        ? Color.fromARGB(255, 233, 16, 16)
                        : Color(0xff0056FF),
                    foregroundColor: driverVM.isOnline
                        ? Color(0xffFFFFFF)
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
