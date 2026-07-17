import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommuterViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final RouteRepository _routeRepo;
  final MapService _mapService;
  final LocationService _locationService;
  final MarkerService _markerService;
  final Set<Marker> _markers = {};
  final PolylinePoints polylinePoints = PolylinePoints();

  CommuterViewModel(
    this._mapService,
    this._locationService,
    this._markerService,
    this._repo,
    this._routeRepo,
  );

  Set<Polyline> polylines = {};
  Set<Marker> get markers => _markers;
  List<Routes> availableRoutes = [];

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);

    await loadRoutes();
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

  Future<void> loadRoute(String routeId) async {
    final route = await _routeRepo.getRoute(routeId);

    final decoded = polylinePoints.decodePolyline(route.encodedPolyline);

    final points = decoded.map((e) => LatLng(e.latitude, e.longitude)).toList();

    polylines = {
      Polyline(
        polylineId: PolylineId(route.id),
        points: points,
        color: route.color,
        width: 6,
      ),
    };

    notifyListeners();
    await _mapService.fitToRoute(points);
  }

  Future<void> loadRoutes() async {
    availableRoutes = await _routeRepo.getRoutes();
    notifyListeners();
  }
}
