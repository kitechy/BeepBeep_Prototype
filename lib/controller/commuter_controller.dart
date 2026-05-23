import 'dart:async';
import 'dart:ui' as ui;
import 'package:beepbeep_prototype/views/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommuterController {
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  StreamSubscription<Position>? positionStream;

  /// Map created callback
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Navigate to settings
  void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  /// Get current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    /// Animate only if controller exists
    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );
    }

    return position;
  }

  /// Builds the user location marker using the authenticated photo URL if available.
  Future<Marker> buildUserLocationMarker(
    Position position,
    String? photoUrl,
  ) async {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

    if (photoUrl != null) {
      markerIcon = await getMarkerFromUrl(photoUrl);
    }

    return Marker(
      markerId: const MarkerId('user_location'),
      position: LatLng(position.latitude, position.longitude),
      icon: markerIcon,
      anchor: const Offset(0.5, 1.0),
      infoWindow: const InfoWindow(title: 'You are here'),
    );
  }

  /// Starts listening to location updates and animates the map camera.
  StreamSubscription<Position> startListeningLocation({
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
    required Future<void> Function(Position) onPosition,
  }) {
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) async {
            await onPosition(position);

            if (mapController != null) {
              await mapController!.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(position.latitude, position.longitude),
                ),
              );
            }
          },
        );

    return positionStream!;
  }

  // Downloads and converts the image of the current user into a Google Maps Marker
  Future<BitmapDescriptor> getMarkerFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    final codec = await ui.instantiateImageCodec(
      response.bodyBytes,
      targetWidth: 200,
      targetHeight: 200,
    );

    final frame = await codec.getNextFrame();
    final image = frame.image;

    const double size = 60;
    const double border = 5;
    const double pointerHeight = 14;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final center = Offset(size / 2, size / 2);

    Paint whitePaint = Paint()
      ..color = Color(0xffFFFFFF)
      ..isAntiAlias = true;

    Paint bluePaint = Paint()
      ..color = Color(0xff0000FF)
      ..isAntiAlias = true;
    // Outer blue circle
    canvas.drawCircle(center, size / 2, bluePaint);
    // Inner white circle
    canvas.drawCircle(center, size / 2.5, whitePaint);

    // Inner clip circle
    final double imageRadius = size / 2 - border;

    canvas.save();

    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: imageRadius)),
    );

    // CENTER CROP (important fix)
    final double srcSize = image.width < image.height
        ? image.width.toDouble()
        : image.height.toDouble();

    final Rect srcRect = Rect.fromLTWH(
      (image.width - srcSize) / 2,
      (image.height - srcSize) / 2,
      srcSize,
      srcSize,
    );

    final Rect dstRect = Rect.fromCircle(center: center, radius: imageRadius);

    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );

    canvas.restore();

    // Pointer
    Path pointer = Path()
      ..moveTo(size / 2 - 12, size - 4)
      ..lineTo(size / 2 + 12, size - 4)
      ..lineTo(size / 2, size + pointerHeight)
      ..close();

    canvas.drawPath(pointer, bluePaint);

    final picture = recorder.endRecording();

    final img = await picture.toImage(
      size.toInt(),
      (size + pointerHeight).toInt(),
    );

    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Future<void> addCurrentUserMarker(LatLng position) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.photoURL == null) return;

    BitmapDescriptor profileMarker = await getMarkerFromUrl(user!.photoURL!);

    Marker currentMarker = Marker(
      markerId: MarkerId('current_user'),
      position: position,
      icon: profileMarker,
      anchor: Offset(0.5, 0.5),
    );

    markers[currentMarker.markerId] = currentMarker;
  }

  void dispose() {
    positionStream?.cancel();
    positionStream = null;
    mapController?.dispose();
    mapController = null;
  }
}
