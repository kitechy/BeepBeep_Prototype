import 'package:beepbeep_prototype/controller/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/login_page.dart';
import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/material.dart';
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

  Future<void> _handleSignOut() async {
    try {
      await signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-Out failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final screenWidth = size.width;
    // final screenHeight = size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu, color: Color(0xff0000FF)),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(color: Color(0xff0000FF)),
              child: Center(
                child: Stack(
                  children: [
                    Text(
                      'Kevin Perez',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButtonWidget(
              text: 'Log out',
              bgColor: Colors.red,
              textColor: Color(0xffFFFFFF),
              onPressed: _handleSignOut,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              width: 250,
              height: 50,
            ),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
        zoomControlsEnabled: false,
      ),
    );
  }
}
