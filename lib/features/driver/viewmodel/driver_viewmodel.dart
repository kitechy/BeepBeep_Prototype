import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/models/routes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final DriverRepository _driverRepo;
  final MapService _mapService;
  final RoutesRepository _routeRepo;
  final PolylinePoints polylinePoints = PolylinePoints();

  DriverViewModel(
    this._repo,
    this._driverRepo,
    this._mapService,
    this._routeRepo,
  );

  String? errorMessage;
  bool isLoading = false;
  bool _disposed = false;
  List<RoutesModel> availableRoutes = [];
  Set<Polyline> polylines = {};

  DriverProfile? driverProfile;

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);
  }

  String get driverName {
    return _repo.currentUser?.displayName ?? "Driver";
  }

  String? get photoUrl {
    return _repo.currentUser?.photoURL;
  }

  bool get isOnline {
    return driverProfile?.status == "online";
  }

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

    await loadRoute(route.id);
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

  Future<bool> logout() async {
    try {
      await _repo.signOut();
      return true;
    } catch (e) {
      errorMessage = "Logout Failed. Please try again.";
      _safeNotify();
      return false;
    }
  }
}
