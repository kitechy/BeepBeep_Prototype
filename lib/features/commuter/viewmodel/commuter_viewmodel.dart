import 'dart:async';

import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/features/commuter/model/jeepney_arrival_estimate.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class CommuterViewModel extends ChangeNotifier {
  // connection to the repositories
  final AuthRepository _repo;
  final UserRepository _userRepo;
  final RoutesRepository _routeRepo;
  final DriverRepository _driverRepo;

  // connection to the services
  final MapService _mapService;
  final LocationService _locationService;
  final MarkerService _markerService;

  final Set<Marker> _markers = {};
  final PolylinePoints polylinePoints = PolylinePoints();
  final List<StreamSubscription> _routeSubscriptions = [];

  final Map<String, LatLng> _driverPositions = {};
  final Map<String, DriverProfile> _drivers = {};

  // stores the active driver count on each route
  final Map<String, int> _activeDriverCounts = {};

  StreamSubscription<List<DriverProfile>>? _driversSubscription;
  DriverProfile? _selectedDriver;
  DriverProfile? get selectedDriver => _selectedDriver;
  UserModel? _selectedDriverUser;
  UserModel? get selectedDriverUser => _selectedDriverUser;

  UserModel? _currentUser;
  LatLng? _commuterPosition;

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

  // stores the routes retrieve from the database
  List<RoutesModel> availableRoutes = [];

  String get commuterName => _currentUser?.name ?? "User";
  String get role => _currentUser?.role ?? "Commuter";
  String? get email => _currentUser?.email;
  String? get photoUrl => _repo.currentUser?.photoURL;
  bool get isGuest => _repo.currentUser?.isAnonymous ?? false;

  // load current user info
  Future<void> loadCurrentUser() async {
    final firebaseUser = _repo.currentUser;

    if (firebaseUser != null && firebaseUser.isAnonymous) {
      _currentUser = UserModel(
        uid: firebaseUser.uid,
        name: 'Guest',
        email: null,
        photoURL: null,
        role: 'commuter',
        profileComplete: false,
      );

      notifyListeners();
      return;
    }

    _currentUser = await _userRepo.getCurrentUser();
    notifyListeners();
  }

  Future<bool> upgradeGuestAccount() async {
    try {
      await _repo.upgradeGuestToGoogle();

      // Reload the now-registered user.
      await loadCurrentUser();

      return true;
    } catch (e) {
      debugPrint('Guest upgrade failed: $e');
      return false;
    }
  }

  // GMaps ready, call this method to load routes and initialize tracking
  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);

    await loadRoutes();
    await initializeTracking();
  }

  // Ask access for location and get current position
  Future<void> initializeTracking() async {
    final granted = await _locationService.requestPermission();
    if (!granted) return;

    // get current location of the device
    final position = await _locationService.getCurrentLocation();
    _commuterPosition = LatLng(position.latitude, position.longitude);

    await _mapService.animateToLocation(position.latitude, position.longitude);

    final user = _repo.currentUser;
    // display the location of user using marker
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

  // load one specific route and display in the map
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

  // get all routes and check active drivers on each route
  Future<void> loadRoutes() async {
    availableRoutes = await _routeRepo.getRoutes();

    await startListeningToActiveDrivers();

    notifyListeners();
  }

  // watches drivers that is online in each route
  Future<void> listenToDrivers(String routeId) async {
    await _driversSubscription?.cancel();

    _driversSubscription = _driverRepo.getOnlineDrivers(routeId).listen((
      drivers,
    ) async {
      _drivers
        ..clear()
        ..addEntries(drivers.map((driver) => MapEntry(driver.uid, driver)));

      if (_selectedDriver != null) {
        _selectedDriver = _drivers[_selectedDriver!.uid];
      }

      notifyListeners();

      // get id of the drivers
      final activeIds = drivers.map((d) => d.uid).toSet();

      _markers.removeWhere((marker) {
        if (!marker.markerId.value.startsWith("driver_")) {
          return false;
        }
        // if it is a jeepney marker, check if it is active
        final uid = marker.markerId.value.replaceFirst("driver_", "");
        return !activeIds.contains(uid);
      });
      // remove driver positions that is not active
      _driverPositions.removeWhere((uid, _) => !activeIds.contains(uid));

      if (_selectedDriver != null &&
          !activeIds.contains(_selectedDriver!.uid)) {
        _selectedDriver = null;
        _selectedDriverUser = null;
      }

      // look for all online drivers and make sure they have location
      for (final driver in drivers) {
        if (driver.latitude == null || driver.longitude == null) {
          continue;
        }

        // create new position for the driver
        final newPosition = LatLng(driver.latitude!, driver.longitude!);
        // check where it is located before
        final oldPosition = _driverPositions[driver.uid];

        // if there is no old position, create a new marker for the driver
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
          // if there is old position, animate the marker to the new position
          await _animateMarker(driver.uid, oldPosition, newPosition);
        }
      }

      notifyListeners();
    });
  }

  Future<void> selectDriver(DriverProfile driver) async {
    _selectedDriver = driver;
    _selectedDriverUser = null;
    notifyListeners();

    final user = await _userRepo.getUserByUid(driver.uid);

    if (_selectedDriver?.uid != driver.uid) return;

    _selectedDriverUser = user;
    notifyListeners();
  }

  void clearSelectedDriver() {
    _selectedDriver = null;
    _selectedDriverUser = null;
    notifyListeners();
  }

  JeepneyArrivalEstimate? getArrivalEstimate(String driverId) {
    final jeepneyPosition = _driverPositions[driverId];
    final commuterPosition = _commuterPosition;

    if (jeepneyPosition == null || commuterPosition == null) return null;

    final distanceMeters = Geolocator.distanceBetween(
      commuterPosition.latitude,
      commuterPosition.longitude,
      jeepneyPosition.latitude,
      jeepneyPosition.longitude,
    );
    final distanceKm = distanceMeters / 1000;
    const averageSpeedKph = 20.0;
    final minutes = max(1, (distanceKm / averageSpeedKph * 60).ceil());

    return JeepneyArrivalEstimate(distanceKm: distanceKm, minutes: minutes);
  }

  // animate marker when driver moves
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

  // calculate which way jeepney is facing, compare the old position and new position to know which way the jeep facing
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

  // get active driver count on each route
  int getActiveDriverCount(String routeId) {
    return _activeDriverCounts[routeId] ?? 0;
  }

  // listening to active drivers on each route
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

  // logout user
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

  // tells map service that camera moved
  void onCameraMove(CameraPosition position) {
    _mapService.onCameraMove(position);
  }

  // reset bearing to 0 and face to north
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
