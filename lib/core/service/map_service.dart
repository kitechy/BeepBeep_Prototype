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
}
