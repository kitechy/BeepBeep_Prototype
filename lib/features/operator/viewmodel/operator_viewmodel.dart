import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/features/operator/model/operator_profile.dart';

import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperatorViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final OperatorRepository _operatorRepo;

  final MapService _mapService;
  OperatorViewModel(this._repo, this._operatorRepo, this._mapService);

  String? errorMessage;
  bool _disposed = false;
  OperatorProfile? operatorProfile;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await _mapService.onMapCreated(controller);
    await loadOperatorProfile();
  }

  Future<void> loadOperatorProfile() async {
    final uid = _repo.currentUser?.uid;

    if (uid == null) return;

    operatorProfile = await _operatorRepo.getOperatorProfile(uid);

    notifyListeners();
  }
}
