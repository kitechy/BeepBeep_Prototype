import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/shared/components/route_bottom_sheet/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/features/commuter/viewmodel/commuter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:beepbeep_prototype/shared/components/drawer/drawer_component.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:beepbeep_prototype/features/about/view/about_page.dart';
import 'package:beepbeep_prototype/shared/widgets/compass_widget.dart';
import 'package:beepbeep_prototype/features/profile/view/profile_page.dart';
import 'package:beepbeep_prototype/features/settings/view/settings_page.dart';

class CommuterHomePage extends StatelessWidget {
  const CommuterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommuterViewModel(
        AuthRepository(AuthService()),
        UserRepository(UserService()),
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

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final commuterVM = context.read<CommuterViewModel>();

      commuterVM.loadCurrentUser();
      commuterVM.setOnJeepneyTap(_showJeepneyArrival);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationServicesPrompt();
    });
  }

  Future<void> _showLocationServicesPrompt() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    var isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    }

    if (isLocationEnabled || !mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Turn on location services'),
          content: const Text(
            'Please enable location services to see nearby jeepneys and get arrival estimates.',
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
        );
      },
    );
  }

  void _showJeepneyArrival(String driverId) {
    final commuterVM = context.read<CommuterViewModel>();
    final estimate = commuterVM.getArrivalEstimate(driverId);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_bus, color: Color(0xff0000FF)),
                    const SizedBox(width: 12),
                    Text(
                      'Jeepney arrival estimate',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (estimate == null)
                  const Text(
                    'Your location is not available yet. Turn on location and try again.',
                  )
                else ...[
                  Text(
                    '${estimate.minutes} min',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${estimate.distanceKm.toStringAsFixed(1)} km away',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Estimated using the jeepney location and an average speed of 20 km/h.',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

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
        builder: (_) => const ErrorDialog(message: 'Log out failed'),
      );
    }
  }

  void navigateToAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutPage()),
    );
  }

  void navigateToProfilePage() {
    final commuterVM = context.read<CommuterViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          name: commuterVM.commuterName,
          email: commuterVM.email,
          photoURL: commuterVM.photoUrl,
          role: commuterVM.role,
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
  Widget build(BuildContext context) {
    final commuterVM = context.watch<CommuterViewModel>();

    return Scaffold(
      key: _scaffoldKey,

      drawer: DrawerComponent(
        currentUser: commuterVM.commuterName,
        role: commuterVM.role,
        photoURL: commuterVM.photoUrl,
        onHomeTap: () {},
        onProfileTap: navigateToProfilePage,
        onSettingsTap: navigateToSettingsPage,
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
            polylines: commuterVM.polylines,
            compassEnabled: false,
            onCameraMove: commuterVM.onCameraMove,
            zoomControlsEnabled: false,
            markers: commuterVM.markers,
            onMapCreated: commuterVM.onMapCreated,
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
            top: MediaQuery.of(context).padding.top + 130,
            right: 16,
            child: CompassWidget(
              bearingStream: commuterVM.bearingStream,
              initialBearing: commuterVM.currentBearing,
              onTap: commuterVM.resetBearing,
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
                    final commuterVM = context.read<CommuterViewModel>();
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return ChangeNotifierProvider.value(
                          value: commuterVM,
                          child: RouteBottomSheet(
                            routes: commuterVM.availableRoutes,
                            onRouteSelected: (route) async {
                              await commuterVM.loadRoute(route.id);
                            },
                            activeDriverCount: commuterVM.getActiveDriverCount,
                          ),
                        );
                      },
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
