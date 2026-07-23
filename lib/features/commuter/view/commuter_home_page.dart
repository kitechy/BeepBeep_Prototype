import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/shared/widgets/route_bottom_sheet.dart';
import 'package:beepbeep_prototype/features/commuter/viewmodel/commuter_viewmodel.dart';
import 'package:beepbeep_prototype/features/profile/view/profile_page.dart';
import 'package:beepbeep_prototype/shared/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CommuterHomePage extends StatelessWidget {
  const CommuterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommuterViewModel(
        MapService(),
        LocationService(),
        MarkerService(),
        AuthRepository(AuthService()),
        RoutesRepository(RoutesService()),
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
  int _selectedIndex = 0;

  final _profilePage = const ProfilePage();
  @override
  Widget build(BuildContext context) {
    final commuterVM = context.watch<CommuterViewModel>();
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff0000FF)),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildMapPage(commuterVM, context), _profilePage],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() {
          _selectedIndex = i;
        }),
      ),
    );
  }
}

Widget _buildMapPage(CommuterViewModel commuterVM, BuildContext context) {
  return Stack(
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
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: Color(0xffFFFFFF),
              onPressed: commuterVM.initializeTracking,
              child: const Icon(Icons.my_location, color: Color(0xff0000FF)),
            ),
          ],
        ),
      ),
    ],
  );
}
