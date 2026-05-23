import 'package:beepbeep_prototype/controller/commuter_controller.dart';
import 'package:beepbeep_prototype/views/pages/routes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuterScreen extends StatefulWidget {
  const CommuterScreen({super.key});

  @override
  State<CommuterScreen> createState() => _CommuterScreenState();
}

class _CommuterScreenState extends State<CommuterScreen> {
  late CommuterController _commuterController;
  final user = FirebaseAuth.instance.currentUser;
  String? photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _commuterController = CommuterController();
    _startListeningLocation();
  }

  @override
  void dispose() {
    _commuterController.dispose();
    super.dispose();
  }

  void _startListeningLocation() {
    _commuterController.startListeningLocation(
      onPosition: (Position position) async {
        if (!mounted) return;

        final marker = await _commuterController.buildUserLocationMarker(
          position,
          photoUrl,
        );

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
    try {
      final position = await _commuterController.getCurrentLocation();

      if (!mounted) return;

      final marker = await _commuterController.buildUserLocationMarker(
        position,
        photoUrl,
      );

      setState(() {
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'user_location',
        );

        _markers.add(marker);
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
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
          GoogleMap(
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
          ),
          Align(alignment: AlignmentGeometry.bottomCenter, child: RoutesPage()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {},
            heroTag: "map_tpe_fab",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            backgroundColor: Color(0xffFFFFFF),
            child: Icon(Icons.map, color: Color(0xff0000FF), size: 24.r),
          ),
          SizedBox(height: 16.r),
          FloatingActionButton(
            onPressed: _centerOnUserLocation,
            heroTag: "location_fab",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            backgroundColor: Color(0xffFFFFFF),
            child: Icon(
              Icons.my_location,
              color: Color(0xff0000FF),
              size: 24.r,
            ),
          ),
        ],
      ),
    );
  }
}
