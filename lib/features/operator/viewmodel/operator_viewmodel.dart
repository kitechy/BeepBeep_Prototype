import 'dart:async';

import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
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

  final MapService _mapService;

  OperatorViewModel(
    this._repo,
    this._userRepo,
    this._operatorRepo,
    this._driverRepo,
    this._mapService,
  );

  OperatorProfile? operatorProfile;
  UserModel? _currentUser;

  List<DriverProfile> _drivers = [];
  List<DriverProfile> get drivers => _drivers;
  StreamSubscription<List<DriverProfile>>? _driverSubscription;

  String? errorMessage;
  bool _disposed = false;

  String get operatorUid => _currentUser?.uid ?? "";

  String get operatorName => _currentUser?.name ?? "User";

  String? get photoUrl => _repo.currentUser?.photoURL;

  String get role => _currentUser?.role ?? "Operator";

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

  void loadDrivers(String operatorUid) {
    _driverSubscription?.cancel();

    _driverSubscription = _driverRepo.getDriversByOperator(operatorUid).listen((
      drivers,
    ) {
      _drivers = drivers;
      notifyListeners();
    });
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
