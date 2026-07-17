import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? get controller => _controller.isCompleted ? null : null;

  Future<void> onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  Future<GoogleMapController> getMapController() async {
    return await _controller.future;
  }

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
}
