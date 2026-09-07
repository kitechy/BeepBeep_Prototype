import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DriverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create/save information of driver profile in database
  Future<void> createDriverProfile(DriverProfile profile) async {
    await _firestore
        .collection('driver_profiles')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  // get driver profile from database using uid
  Future<DriverProfile?> getDriverProfile(String uid) async {
    final doc = await _firestore.collection('driver_profiles').doc(uid).get();

    if (!doc.exists) return null;

    return DriverProfile.fromMap(doc.data()!);
  }

  // listen to driver profile changes in database using uid
  Stream<DriverProfile?> listenToDriver(String uid) {
    return _firestore.collection('driver_profiles').doc(uid).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return DriverProfile.fromMap(snapshot.data()!);
    });
  }

  // update driver profile in database
  Future<void> updateDriverProfile(DriverProfile profile) async {
    await _firestore
        .collection('driver_profiles')
        .doc(profile.uid)
        .update(profile.toMap());
  }

  Future<void> updateDriverStatus(String uid, String status) async {
    await _firestore.collection('driver_profiles').doc(uid).update({
      'status': status,
    });
  }

  Future<void> updateOccupiedSeats(String driverUid, int occupiedSeats) async {
    await _firestore
        .collection('driver_profiles')
        .doc(driverUid)
        .update({'occupiedSeats': occupiedSeats});
  }

  // update current route of driver in database
  Future<void> updateCurrentRoute(String uid, String routeId) async {
    await _firestore.collection('driver_profiles').doc(uid).update({
      'currentRouteId': routeId,
    });
  }

  // update location of driver in database
  Future<void> updateDriverLocation(
    String uid,
    double latitude,
    double longitude,
  ) async {
    await _firestore.collection('driver_profiles').doc(uid).update({
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> incrementTotalPassengers(String uid, int count) async {
  await _firestore
      .collection('driver_profiles')
      .doc(uid)
      .update({
        'totalPassengers': FieldValue.increment(count),
      });
}

  // get online drivers for a route from database
  Stream<List<DriverProfile>> getOnlineDrivers(String routeId) {
    return _firestore
        .collection('driver_profiles')
        .where('status', isEqualTo: 'online')
        .where('currentRouteId', isEqualTo: routeId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DriverProfile.fromMap(doc.data()))
              .toList();
        });
  }

  Stream<List<DriverProfile>> getDriversByOperator(String operatorUid) {
    return _firestore
        .collection('driver_profiles')
        .where('operatorUid', isEqualTo: operatorUid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DriverProfile.fromMap(doc.data()))
              .toList(),
        );
  }
}
