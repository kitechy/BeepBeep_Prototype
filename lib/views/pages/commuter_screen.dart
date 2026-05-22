import 'package:beepbeep_prototype/views/pages/drawer_screen.dart';
import 'package:beepbeep_prototype/views/routes/routes.dart';
import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuterHomePage extends StatefulWidget {
  const CommuterHomePage({super.key});

  @override
  State<CommuterHomePage> createState() => _CommuterHomePageState();
}

class _CommuterHomePageState extends State<CommuterHomePage> {
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
        leading: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.all(8.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(50.r),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu, color: Color(0xff0000FF), size: 24.r),
              ),
            ),
          ),
        ),
      ),
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 50.h,
            left: 20.w,
            right: 20.w,
            child: ElevatedButtonWidget(
              text: 'Change route',
              bgColor: Color(0xff0000FF),
              textColor: Color(0xffFFFFFF),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const Routes(),
                );
              },
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,

              borderColor: Color(0xff0000ff),
            ),
          ),
        ],
      ),
    );
  }
}
