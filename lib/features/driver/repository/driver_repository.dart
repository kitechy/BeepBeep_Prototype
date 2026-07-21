import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';

class DriverRepository {
  final DriverService _driverService;

  DriverRepository(this._driverService);

  Future<void> createDriverProfile(DriverProfile profile) async {
    await _driverService.createDriverProfile(profile);
  }

  Future<DriverProfile?> getDriverProfile(String uid) async {
    return await _driverService.getDriverProfile(uid);
  }

  Future<void> updateDriverProfile(DriverProfile profile) async {
    await _driverService.updateDriverProfile(profile);
  }

  Future<void> updateDriverStatus(String uid, String status) async {
    await _driverService.updateDriverStatus(uid, status);
  }
}
