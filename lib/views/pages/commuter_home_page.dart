import 'package:beepbeep_prototype/controller/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuterHomePage extends StatefulWidget {
  const CommuterHomePage({super.key});

  @override
  State<CommuterHomePage> createState() => _CommuterHomePageState();
}

class _CommuterHomePageState extends State<CommuterHomePage> {
  late GoogleMapController mapController;

  final LatLng legazpiCity = const LatLng(13.1391, 123.7438);

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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xffFFFFFF)),
      ),
      drawer: Drawer(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: legazpiCity, zoom: 12.0),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff0000FF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: _handleSignOut,
              icon: Icon(Icons.logout, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
