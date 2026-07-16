import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuterViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final MapService _mapService;
  final LocationService _locationService;
  final MarkerService _markerService;
  final Set<Marker> _markers = {};
  CommuterViewModel(
    this._mapService,
    this._locationService,
    this._markerService,
    this._repo,
  );

  Set<Marker> get markers => _markers;

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);

    await initializeTracking();
  }

  Future<void> initializeTracking() async {
    final granted = await _locationService.requestPermission();
    if (!granted) return;

    final position = await _locationService.getCurrentLocation();

    await _mapService.animateToLocation(position.latitude, position.longitude);

    final user = _repo.currentUser;

    if (user != null) {
      final marker = await _markerService.buildMarker(
        id: "current_user",
        position: LatLng(position.latitude, position.longitude),
        photoUrl: user.photoURL,
        title: "You",
      );

      _markers
        ..removeWhere((m) => m.markerId == marker.markerId)
        ..add(marker);

      notifyListeners();
    }
  }
}
