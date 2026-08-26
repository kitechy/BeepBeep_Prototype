import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  // GMaps controller
  final Completer<GoogleMapController> _controller = Completer();

  // tells the other part of the app that the maps direction changed
  final StreamController<double> _bearingController =
      StreamController<double>.broadcast();

  Stream<double> get bearingStream => _bearingController.stream;
  // stores the current direction of the map
  double _currentBearing = 0;

  // allows classes to read current bearing
  double get currentBearing => _currentBearing;

  GoogleMapController? get controller => _controller.isCompleted ? null : null;

  // runs when google finish creating the map
  Future<void> onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  // runs when the camera move
  void onCameraMove(CameraPosition position) {
    _currentBearing = position.bearing;
    _bearingController.add(position.bearing);
  }

  // gives the control to the map when its ready
  Future<GoogleMapController> getMapController() async {
    return await _controller.future;
  }

  // moves the camera to a specific location
  Future<void> animateToLocation(double latitude, double longitude) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 16),
      ),
    );
  }

  Future<void> zoomIn() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> zoomOut() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  // fits the map to the route
  Future<void> fitToRoute(List<LatLng> points) async {
    if (points.isEmpty) return;

    final controller = await _controller.future;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  void dispose() {
    _bearingController.close();
  }
}
