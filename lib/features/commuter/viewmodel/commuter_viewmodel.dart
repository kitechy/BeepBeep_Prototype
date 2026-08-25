import 'dart:async';

import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class CommuterViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final UserRepository _userRepo;
  final RoutesRepository _routeRepo;
  final DriverRepository _driverRepo;

  final MapService _mapService;
  final LocationService _locationService;
  final MarkerService _markerService;

  final Set<Marker> _markers = {};
  final PolylinePoints polylinePoints = PolylinePoints();
  final List<StreamSubscription> _routeSubscriptions = [];

  final Map<String, LatLng> _driverPositions = {};
  final Map<String, int> _activeDriverCounts = {};
  final Map<String, DriverProfile> _drivers = {};

  StreamSubscription<List<DriverProfile>>? _driversSubscription;
  DriverProfile? _selectedDriver;
  DriverProfile? get selectedDriver => _selectedDriver;

  UserModel? _currentUser;

  CommuterViewModel(
    this._repo,
    this._userRepo,
    this._routeRepo,
    this._driverRepo,

    this._mapService,
    this._locationService,
    this._markerService,
  );

  Set<Polyline> polylines = {};
  Set<Marker> get markers => _markers;

  List<RoutesModel> availableRoutes = [];

  String get commuterName => _currentUser?.name ?? "User";

  String get role => _currentUser?.role ?? "Commuter";

  String? get email => _currentUser?.email;

  String? get photoUrl => _repo.currentUser?.photoURL;

  Future<void> loadCurrentUser() async {
    _currentUser = await _userRepo.getCurrentUser();
    notifyListeners();
  }

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
    await listenToDrivers(routeId);
  }

  Future<void> loadRoutes() async {
    availableRoutes = await _routeRepo.getRoutes();

    await startListeningToActiveDrivers();

    notifyListeners();
  }

  Future<void> listenToDrivers(String routeId) async {
    await _driversSubscription?.cancel();

    _driversSubscription = _driverRepo.getOnlineDrivers(routeId).listen((
      drivers,
    ) async {
      final activeIds = drivers.map((d) => d.uid).toSet();

      _drivers
        ..clear()
        ..addEntries(drivers.map((driver) => MapEntry(driver.uid, driver)));

      _markers.removeWhere((marker) {
        if (!marker.markerId.value.startsWith("driver_")) {
          return false;
        }

        final uid = marker.markerId.value.replaceFirst("driver_", "");

        return !activeIds.contains(uid);
      });

      _driverPositions.removeWhere((uid, _) => !activeIds.contains(uid));

      if (_selectedDriver != null &&
          !activeIds.contains(_selectedDriver!.uid)) {
        _selectedDriver = null;
      }

      for (final driver in drivers) {
        if (driver.latitude == null || driver.longitude == null) {
          continue;
        }

        final newPosition = LatLng(driver.latitude!, driver.longitude!);

        final oldPosition = _driverPositions[driver.uid];

        if (oldPosition == null) {
          final marker = await _markerService.buildJeepneyMarker(
            id: "driver_${driver.uid}",
            position: newPosition,
            availableSeats: driver.availableSeats,
            totalSeats: driver.totalSeats,
            title: "Jeepney",
            onTap: () {
              selectDriver(driver);
            },
          );

          _markers.add(marker);
          _driverPositions[driver.uid] = newPosition;
        } else {
          await _animateMarker(driver.uid, oldPosition, newPosition);
        }
      }

      // Update selected driver with the newest Firestore data.
      if (_selectedDriver != null) {
        _selectedDriver = _drivers[_selectedDriver!.uid];
      }

      notifyListeners();
    });
  }

  void selectDriver(DriverProfile driver) {
    _selectedDriver = driver;
    notifyListeners();
  }

  void clearSelectedDriver() {
    _selectedDriver = null;
    notifyListeners();
  }

  Future<void> _animateMarker(String driverId, LatLng from, LatLng to) async {
    const int steps = 25;
    const Duration frameDuration = Duration(milliseconds: 40);

    final driver = _drivers[driverId];

    for (int i = 1; i <= steps; i++) {
      final position = LatLng(
        from.latitude + (to.latitude - from.latitude) * i / steps,
        from.longitude + (to.longitude - from.longitude) * i / steps,
      );

      final rotation = _calculateBearing(from, to);

      final marker = await _markerService.buildJeepneyMarker(
        id: "driver_$driverId",
        position: position,
        availableSeats: driver?.availableSeats ?? 0,
        totalSeats: driver?.totalSeats ?? 0,
        title: "Jeepney",
        rotation: rotation,
        onTap: driver == null
            ? null
            : () {
                selectDriver(driver);
              },
      );

      _markers.removeWhere((m) => m.markerId.value == "driver_$driverId");

      _markers.add(marker);

      notifyListeners();

      await Future.delayed(frameDuration);
    }

    _driverPositions[driverId] = to;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lon1 = start.longitude * pi / 180;

    final lat2 = end.latitude * pi / 180;
    final lon2 = end.longitude * pi / 180;

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);

    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    var bearing = atan2(y, x);

    bearing = bearing * 180 / pi;

    return (bearing + 360) % 360;
  }

  int getActiveDriverCount(String routeId) {
    return _activeDriverCounts[routeId] ?? 0;
  }

  Future<void> startListeningToActiveDrivers() async {
    for (final sub in _routeSubscriptions) {
      await sub.cancel();
    }
    _routeSubscriptions.clear();

    for (final route in availableRoutes) {
      final sub = _driverRepo.getOnlineDrivers(route.id).listen((drivers) {
        _activeDriverCounts[route.id] = drivers.length;
        notifyListeners();
      });

      _routeSubscriptions.add(sub);
    }
  }

  Future<bool> logout() async {
    try {
      await _driversSubscription?.cancel();
      _driversSubscription = null;

      for (final sub in _routeSubscriptions) {
        await sub.cancel();
      }
      _routeSubscriptions.clear();

      await _repo.signOut();

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<double> get bearingStream => _mapService.bearingStream;
  double get currentBearing => _mapService.currentBearing;

  void onCameraMove(CameraPosition position) {
    _mapService.onCameraMove(position);
  }

  Future<void> resetBearing() async {
    final controller = await _mapService.getMapController();
    final zoomLevel = await controller.getZoomLevel();
    final visibleRegion = await controller.getVisibleRegion();

    final center = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: zoomLevel, bearing: 0),
      ),
    );
  }

  @override
  void dispose() {
    _driversSubscription?.cancel();

    for (final sub in _routeSubscriptions) {
      sub.cancel();
    }

    _routeSubscriptions.clear();

    super.dispose();
  }
}
