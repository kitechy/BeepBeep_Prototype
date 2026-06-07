import 'package:beepbeep_prototype/features/commuter/viewmodel/commuter_viewmodel.dart';
import 'package:beepbeep_prototype/features/map/viewmodel/map_type_controller.dart';
import 'package:beepbeep_prototype/features/auth/view/widgets/draggable_sheet.dart';
import 'package:beepbeep_prototype/shared/widgets/fab_buttons.dart';
import 'package:beepbeep_prototype/features/map/view/widgets/map_type_sheet.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _CommuterScreenState();
}

class _CommuterScreenState extends State<TrackingPage> {
  late CommuterController _commuterController;
  late MapTypeController _mapTypeController;
  late DraggableScrollableController _sheetController;
  String? photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _mapTypeController = MapTypeController();
    _commuterController = CommuterController();
    _mapTypeController.loadMapType();
    _startListeningLocation();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _commuterController.dispose();
    _mapTypeController.dispose();
    super.dispose();
  }

  void _startListeningLocation() {
    _commuterController.startListeningLocation(
      onPosition: (Position position) async {
        final marker = await _commuterController.buildUserLocationMarker(
          position,
          photoUrl,
        );

        if (!mounted) return;

        setState(() {
          _markers.removeWhere(
            (marker) => marker.markerId.value == 'user_location',
          );

          _markers.add(marker);
        });
      },
    );
  }

  Future<void> _centerOnUserLocation() async {
    final position = await _commuterController.handleLocationPermission(
      context,
    );

    final marker = await _commuterController.buildUserLocationMarker(
      position,
      photoUrl,
    );

    if (!mounted) return;

    setState(() {
      _markers.removeWhere(
        (marker) => marker.markerId.value == 'user_location',
      );

      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              _commuterController.navigateToSettings(context);
            },
            child: Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(50.r),
              ),
              margin: EdgeInsets.only(right: 16.w),
              child: Icon(Icons.settings, color: Color(0xff0000FF), size: 24.r),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: _mapTypeController.mapTypeNotifier,
            builder: (context, MapType mapType, child) {
              return GoogleMap(
                onMapCreated: (controller) {
                  _commuterController.onMapCreated(controller);
                  _centerOnUserLocation();
                },
                markers: _markers,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(13.1391, 123.7438),
                  zoom: 13.0,
                ),
                zoomControlsEnabled: false,
                mapType: mapType,
              );
            },
          ),
          DraggableSheet(controller: _sheetController),
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              double sheetSize = _sheetController.isAttached
                  ? _sheetController.size
                  : 0.4;
              return Positioned(
                right: 20.w,
                bottom: sheetSize * MediaQuery.of(context).size.height + 10.h,
                child: Column(
                  spacing: 16.0,
                  children: [
                    FabButtonWidget(
                      onPressed: () => showBottomSheet(
                        context: context,
                        builder: (context) =>
                            MapTypeSheet(mapTypeController: _mapTypeController),
                      ),
                      heroTag: "map_type_fab",
                      icon: Icons.map,
                    ),
                    FabButtonWidget(
                      onPressed: _centerOnUserLocation,
                      heroTag: "location_fab",
                      icon: Icons.my_location,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
