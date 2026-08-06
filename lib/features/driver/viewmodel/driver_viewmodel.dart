import 'dart:async';
import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/location_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final UserRepository _userRepo;
  final DriverRepository _driverRepo;
  final RoutesRepository _routeRepo;

  final MapService _mapService;
  final LocationService _locationService;
  final MarkerService _markerService;

  final PolylinePoints polylinePoints = PolylinePoints();
  final Set<Marker> _markers = {};

  DriverViewModel(
    this._repo,
    this._userRepo,
    this._driverRepo,
    this._mapService,
    this._routeRepo,
    this._locationService,
    this._markerService,
  );

  String? errorMessage;
  bool isLoading = false;
  bool _disposed = false;

  List<RoutesModel> availableRoutes = [];

  Set<Marker> get markers => _markers;
  Set<Polyline> polylines = {};

  DriverProfile? driverProfile;
  UserModel? _currentUser;
  RoutesModel? _selectedRoute;

  StreamSubscription<Position>? _locationSubscription;

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);
  }

  String get driverName => _currentUser?.name ?? "User";

  String get role => _currentUser?.role ?? 'Driver';

  String? get photoUrl => _repo.currentUser?.photoURL;

  bool get isOnline => driverProfile?.status == "online";

  String? get currentRouteName => _selectedRoute?.name;

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> loadCurrentUser() async {
    _currentUser = await _userRepo.getCurrentUser();
    notifyListeners();
  }

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

  Future<void> toggleStatus() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) {
      errorMessage = "User not logged in.";
      _safeNotify();
      return;
    }

    try {
      final newStatus = isOnline ? "offline" : "online";

      await _driverRepo.updateDriverStatus(uid, newStatus);

      driverProfile = driverProfile!.copyWith(status: newStatus);

      if (newStatus == "online") {
        await startLocationTracking();
      } else {
        await stopLocationTracking();
      }

      _safeNotify();
    } catch (e) {
      errorMessage = e.toString();
      _safeNotify();
    }
  }

  Future<void> loadRoutes() async {
    availableRoutes = await _routeRepo.getRoutes();
    notifyListeners();
  }

  Future<void> selectRoute(RoutesModel route) async {
    final uid = _repo.currentUser?.uid;

    if (uid == null || driverProfile == null) return;

    await _driverRepo.updateCurrentRoute(uid, route.id);

    driverProfile = driverProfile!.copyWith(currentRouteId: route.id);

    _selectedRoute = route;

    await loadRoute(route.id);
  }

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

    notifyListeners();
  }

  Future<void> startLocationTracking() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) return;

    final granted = await _locationService.requestPermission();

    if (!granted) {
      errorMessage = "Location permission denied.";
      _safeNotify();
      return;
    }

    final current = await _locationService.getCurrentLocation();

    await _driverRepo.updateDriverLocation(
      uid,
      current.latitude,
      current.longitude,
    );

    await _updateDriverMarker(current);

    await _mapService.animateToLocation(current.latitude, current.longitude);

    await _locationSubscription?.cancel();

    _locationSubscription = _locationService.getLocationStream().listen((
      position,
    ) async {
      if (_repo.currentUser == null) return;

      await _driverRepo.updateDriverLocation(
        uid,
        position.latitude,
        position.longitude,
      );

      await _updateDriverMarker(position);

      await _mapService.animateToLocation(
        position.latitude,
        position.longitude,
      );
    });
  }

  Future<void> stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> _updateDriverMarker(Position position) async {
    final user = _repo.currentUser;

    if (user == null) return;

    final marker = await _markerService.buildMarker(
      id: "driver",
      position: LatLng(position.latitude, position.longitude),
      photoUrl: user.photoURL,
      title: driverName,
    );

    _markers
      ..removeWhere((m) => m.markerId == marker.markerId)
      ..add(marker);

    _safeNotify();
  }

  Future<bool> logout() async {
    final uid = _repo.currentUser?.uid;

    try {
      if (uid != null) {
        await stopLocationTracking();

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
    (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
  );

  controller.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: center,
        zoom: zoomLevel,
        bearing: 0,
      ),
    ),
  );
}

  @override
  void dispose() {
    _disposed = true;

    _locationSubscription?.cancel();

    super.dispose();
  }
}
