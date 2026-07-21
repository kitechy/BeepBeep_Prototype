import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final DriverRepository _driverRepo;
  final MapService _mapService;

  DriverViewModel(this._repo, this._driverRepo, this._mapService);

  String? errorMessage;
  bool isLoading = false;
  bool _disposed = false;

  DriverProfile? driverProfile;

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);
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
}
