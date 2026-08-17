import 'dart:async';

import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/core/service/marker_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/operator/model/operator_profile.dart';

import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperatorViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final UserRepository _userRepo;
  final OperatorRepository _operatorRepo;
  final DriverRepository _driverRepo;
  final RoutesRepository _routesRepo;

  final MapService _mapService;
  final MarkerService _markerService;

  OperatorViewModel(
    this._repo,
    this._userRepo,
    this._operatorRepo,
    this._driverRepo,
    this._routesRepo,

    this._mapService,
    this._markerService,
  );

  OperatorProfile? operatorProfile;
  UserModel? _currentUser;

  List<DriverProfile> _drivers = [];
  List<DriverProfile> get drivers => _drivers;
  StreamSubscription<List<DriverProfile>>? _driverSubscription;

  DriverProfile? _selectedDriver;
  DriverProfile? get selectedDriver => _selectedDriver;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  final Map<String, String> _driverNames = {};
  final Map<String, LatLng> _driverPositions = {};
  final Map<String, String> _routeNames = {};
  Map<String, String> get driverNames => _driverNames;
  Map<String, String> get routeNames => _routeNames;

  String? errorMessage;
  bool _disposed = false;

  String get operatorUid => _currentUser?.uid ?? "";

  String get operatorName => _currentUser?.name ?? "User";

  String? get photoUrl => _repo.currentUser?.photoURL;

  String get role => _currentUser?.role ?? "Operator";

  String? get email => _currentUser?.email;

  int get fleetCount => _drivers.length;

  int get onlineCount => _drivers.where((d) => d.status == "online").length;

  int get offlineCount => _drivers.where((d) => d.status == "offline").length;

  Future<void> loadCurrentUser() async {
    _currentUser = await _userRepo.getCurrentUser();
    notifyListeners();
  }

  Future<void> loadOperatorProfile() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) return;

    operatorProfile = await _operatorRepo.getOperatorProfile(uid);

    notifyListeners();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);
    await loadOperatorProfile();
  }

  void selectDriver(DriverProfile driver) {
    _selectedDriver = driver;
    notifyListeners();
  }

  void clearSelectedDriver() {
    _selectedDriver = null;
    notifyListeners();
  }

  Future<void> loadDrivers(String operatorUid) async {
    await _driverSubscription?.cancel();

    _driverSubscription = _driverRepo.getDriversByOperator(operatorUid).listen((
      drivers,
    ) async {
      _drivers = drivers;
      await loadDriverDisplayData(drivers);

      final activeIds = drivers
          .where(
            (driver) =>
                driver.status == 'online' &&
                driver.latitude != null &&
                driver.longitude != null,
          )
          .map((driver) => driver.uid)
          .toSet();

      _markers.removeWhere((marker) {
        if (!marker.markerId.value.startsWith('driver_')) {
          return false;
        }

        final uid = marker.markerId.value.replaceFirst('driver_', '');

        return !activeIds.contains(uid);
      });

      _driverPositions.removeWhere((uid, _) => !activeIds.contains(uid));

      if (_selectedDriver != null) {
        final selectedStillOnline = activeIds.contains(_selectedDriver!.uid);

        if (!selectedStillOnline) {
          _selectedDriver = null;
        }
      }

      for (final driver in drivers) {
        if (driver.status != 'online') {
          continue;
        }

        if (driver.latitude == null || driver.longitude == null) {
          continue;
        }

        final position = LatLng(driver.latitude!, driver.longitude!);

        final marker = await _markerService.buildJeepneyMarker(
          id: 'driver_${driver.uid}',
          position: position,
          onTap: () => selectDriver(driver),
        );

        _markers.removeWhere(
          (marker) => marker.markerId.value == 'driver_${driver.uid}',
        );

        _markers.add(marker);

        _driverPositions[driver.uid] = position;
      }

      _safeNotify();
    });
  }

  Future<void> loadDriverDisplayData(List<DriverProfile> drivers) async {
    _driverNames.clear();
    _routeNames.clear();

    final routeIds = <String>{};

    for (final driver in drivers) {
      // Collect route IDs
      if (driver.currentRouteId != null && driver.currentRouteId!.isNotEmpty) {
        routeIds.add(driver.currentRouteId!);
      }
    }

    // Load driver names
    await Future.wait(
      drivers.map((driver) async {
        try {
          final user = await _userRepo.getUserByUid(driver.uid);

          if (user?.name != null && user!.name!.trim().isNotEmpty) {
            _driverNames[driver.uid] = user.name!.trim();
          }
        } catch (e) {
          debugPrint('Failed to load driver name for ${driver.uid}: $e');
        }
      }),
    );

    // Load route names
    await Future.wait(
      routeIds.map((routeId) async {
        try {
          final route = await _routesRepo.getRoute(routeId);

          if (route.name.trim().isNotEmpty) {
            _routeNames[routeId] = route.name.trim();
          }
        } catch (e) {
          debugPrint('Failed to load route $routeId: $e');
        }
      }),
    );

    _safeNotify();
  }

  Future<bool> logout() async {
    try {
      await _repo.signOut();
      return true;
    } catch (e) {
      errorMessage = e.toString();
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
    _disposed = true;
    _driverSubscription?.cancel();
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }
}
