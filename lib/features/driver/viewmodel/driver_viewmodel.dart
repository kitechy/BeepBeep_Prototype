import 'dart:async';

import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/background_location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final UserRepository _userRepo;
  final DriverRepository _driverRepo;
  final RoutesRepository _routeRepo;
  final OperatorRepository _operatorRepo;

  final MapService _mapService;
  final MarkerService _markerService;

  final PolylinePoints polylinePoints = PolylinePoints();

  final Set<Marker> _markers = {};

  DriverViewModel(
    this._repo,
    this._userRepo,
    this._driverRepo,
    this._routeRepo,
    this._operatorRepo,

    this._mapService,
    this._markerService,
  );

  String? errorMessage;

  bool isLoading = false;

  bool _disposed = false;

  bool _mapReady = false;

  final bool _followDriver = true;

  List<RoutesModel> availableRoutes = [];

  Set<Marker> get markers => _markers;

  Set<Polyline> polylines = {};

  DriverProfile? driverProfile;

  UserModel? _currentUser;

  RoutesModel? _selectedRoute;

  StreamSubscription<DriverProfile?>? _driverSubscription;

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // MAP
  void onMapCreated(GoogleMapController controller) {
    _mapReady = true;
    _mapService.onMapCreated(controller);

    final lat = driverProfile?.latitude;
    final lng = driverProfile?.longitude;

    if (lat != null && lng != null) {
      _followDriverLocation(LatLng(lat, lng), force: true);
    }
  }

  // USER
  String get driverName {
    return _currentUser?.name ?? "User";
  }

  String get role {
    return _currentUser?.role ?? "Driver";
  }

  String? get email {
    return _currentUser?.email;
  }

  String? get photoUrl {
    return _repo.currentUser?.photoURL;
  }

  // DRIVER STATUS
  bool get isOnline {
    return driverProfile?.status == "online";
  }

  // ROUTE
  String? get currentRouteName {
    return _selectedRoute?.name;
  }

  // GREETING
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 18) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  // LOAD CURRENT USER
  Future<void> loadCurrentUser() async {
    _currentUser = await _userRepo.getCurrentUser();

    _safeNotify();
  }

  // LOAD DRIVER PROFILE
  Future<void> loadDriverProfile() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) {
      errorMessage = "User not logged in.";

      _safeNotify();

      return;
    }

    try {
      isLoading = true;

      _safeNotify();

      driverProfile = await _driverRepo.getDriverProfile(uid);

      if (driverProfile?.currentRouteId != null) {
        await loadRoute(driverProfile!.currentRouteId!);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      _safeNotify();
    }
  }

  Future<void> startListeningToMyLocation() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) return;

    await _driverSubscription?.cancel();

    _driverSubscription = _driverRepo
        .listenToDriver(uid)
        .listen(
          (driver) async {
            if (driver == null) return;

            driverProfile = driver;

            final latitude = driver.latitude;
            final longitude = driver.longitude;

            if (latitude == null || longitude == null) {
              _safeNotify();
              return;
            }

            final position = LatLng(latitude, longitude);

            final marker = await _markerService.buildMarker(
              id: 'driver',
              position: position,
              photoUrl: _repo.currentUser?.photoURL,
              title: driverName,
            );

            _markers
              ..removeWhere((marker) => marker.markerId.value == 'driver')
              ..add(marker);

            // Automatically follow the driver's location
            await _followDriverLocation(position);

            _safeNotify();
          },
          onError: (error) {
            errorMessage = error.toString();
            _safeNotify();
          },
        );
  }

  Future<void> _followDriverLocation(
    LatLng position, {
    bool force = false,
  }) async {
    if (!_mapReady) return;
    if (!_followDriver && !force) return;

    final controller = await _mapService.getMapController();

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 17,
          bearing: _mapService.currentBearing,
          tilt: 0,
        ),
      ),
    );
  }

  Future<bool> connectToOperator(String code) async {
    final operatorCode = code.trim();

    if (operatorCode.isEmpty) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final operator = await _operatorRepo.getOperatorByCode(operatorCode);

      if (operator == null) {
        errorMessage = 'Invalid operator code.';
        return false;
      }

      final driverUid = _repo.currentUser?.uid;

      if (driverUid == null) {
        errorMessage = 'User not logged in.';
        return false;
      }

      await _driverRepo.connectToOperator(driverUid, operator.uid);

      if (driverProfile != null) {
        driverProfile = driverProfile!.copyWith(operatorUid: operator.uid);
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PASSENGER COUNT
  Future<void> updateOccupiedSeats(int occupiedSeats) async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) {
      errorMessage = "User not logged in.";
      _safeNotify();
      throw StateError(errorMessage!);
    }

    if (driverProfile == null) {
      errorMessage = "Driver profile is still loading.";
      _safeNotify();
      throw StateError(errorMessage!);
    }

    final totalSeats = driverProfile!.totalSeats;

    if (occupiedSeats < 0 || occupiedSeats > totalSeats) {
      errorMessage = "Passenger count must be between 0 and $totalSeats.";

      _safeNotify();
      throw StateError(errorMessage!);
    }

    try {
      await _driverRepo.updateOccupiedSeats(uid, occupiedSeats);

      // Reload the updated profile
      driverProfile = await _driverRepo.getDriverProfile(uid);

      _safeNotify();
    } catch (e) {
      errorMessage = e.toString();
      _safeNotify();
      rethrow;
    }
  }

  // TOGGLE ONLINE / OFFLINE
  Future<void> toggleStatus() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) {
      errorMessage = "User not logged in.";
      _safeNotify();
      return;
    }

    try {
      if (isOnline) {
        await BackgroundLocationService.stop();

        await _driverRepo.updateDriverStatus(uid, "offline");

        driverProfile = driverProfile!.copyWith(status: "offline");

        _safeNotify();

        return;
      }

      final locationEnabled = await Geolocator.isLocationServiceEnabled();

      if (!locationEnabled) {
        errorMessage = "Please enable location services on your device.";

        _safeNotify();

        return;
      }

      PermissionStatus locationPermission = await Permission.location.request();

      if (!locationPermission.isGranted) {
        errorMessage = "Location permission is required for live tracking.";

        _safeNotify();

        return;
      }

      PermissionStatus backgroundPermission = await Permission.locationAlways
          .request();

      if (!backgroundPermission.isGranted) {
        errorMessage =
            "Allow 'Always' location permission for background tracking.";

        _safeNotify();

        return;
      }

      PermissionStatus notificationPermission = await Permission.notification
          .request();

      if (!notificationPermission.isGranted) {
        errorMessage = "Notification permission is required for live tracking.";

        _safeNotify();

        return;
      }

      await _driverRepo.updateDriverStatus(uid, "online");

      driverProfile = driverProfile!.copyWith(status: "online");

      _safeNotify();

      await BackgroundLocationService.start();
    } catch (e) {
      errorMessage = e.toString();

      _safeNotify();
    }
  }

  // LOAD ROUTES
  Future<void> loadRoutes() async {
    availableRoutes = await _routeRepo.getRoutes();

    _safeNotify();
  }

  // SELECT ROUTE
  Future<void> selectRoute(RoutesModel route) async {
    final uid = _repo.currentUser?.uid;

    if (uid == null || driverProfile == null) {
      return;
    }

    await _driverRepo.updateCurrentRoute(uid, route.id);

    driverProfile = driverProfile!.copyWith(currentRouteId: route.id);

    _selectedRoute = route;

    await loadRoute(route.id);
  }

  // LOAD ROUTE
  Future<void> loadRoute(String routeId) async {
    final route = await _routeRepo.getRoute(routeId);

    _selectedRoute = route;

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

    await _mapService.fitToRoute(points);

    _safeNotify();
  }

  // BEARING
  Stream<double> get bearingStream {
    return _mapService.bearingStream;
  }

  double get currentBearing {
    return _mapService.currentBearing;
  }

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

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: zoomLevel, bearing: 0),
      ),
    );
  }

  // LOGOUT
  Future<bool> logout() async {
    final uid = _repo.currentUser?.uid;

    try {
      if (uid != null) {
        // Stop background location service.
        BackgroundLocationService.stop();

        // Set driver offline.
        await _driverRepo.updateDriverStatus(uid, "offline");

        if (driverProfile != null) {
          driverProfile = driverProfile!.copyWith(status: "offline");
        }
      }

      await _repo.signOut();

      return true;
    } catch (e) {
      errorMessage = "Logout Failed. Please try again.";

      _safeNotify();

      return false;
    }
  }

  // DISPOSE
  @override
  void dispose() {
    _disposed = true;

    _driverSubscription?.cancel();
    _driverSubscription = null;
    super.dispose();
  }
}
