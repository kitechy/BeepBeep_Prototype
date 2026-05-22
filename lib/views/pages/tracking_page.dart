import 'package:beepbeep_prototype/views/pages/routes_page.dart';
import 'package:beepbeep_prototype/views/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.1391, 123.7438);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
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
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
            zoomControlsEnabled: false,
          ),
          Align(alignment: AlignmentGeometry.bottomCenter, child: RoutesPage()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        backgroundColor: Color(0xffFFFFFF),
        onPressed: () {},
        child: Icon(Icons.my_location, color: Color(0xff0000FF), size: 24.r),
      ),
    );
  }
}
