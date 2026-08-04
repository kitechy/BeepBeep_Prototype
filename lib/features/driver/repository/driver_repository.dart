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

  Future<void> updateCurrentRoute(String uid, String routeId) {
    return _driverService.updateCurrentRoute(uid, routeId);
  }

  Future<void> updateDriverLocation(
    String uid,
    double latitude,
    double longitude,
  ) {
    return _driverService.updateDriverLocation(uid, latitude, longitude);
  }

  Stream<List<DriverProfile>> getOnlineDrivers(String routeId) {
    return _driverService.getOnlineDrivers(routeId);
  }

  Stream<List<DriverProfile>> getDriversByOperator(String operatorUid) {
    return _driverService.getDriversByOperator(operatorUid);
  }
}
