import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DriverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDriverProfile(DriverProfile profile) async {
    await _firestore
        .collection('driver_profiles')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  Future<DriverProfile?> getDriverProfile(String uid) async {
    final doc = await _firestore.collection('driver_profiles').doc(uid).get();

    if (!doc.exists) return null;

    return DriverProfile.fromMap(doc.data()!);
  }

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

  Future<void> updateCurrentRoute(String uid, String routeId) async {
    await _firestore.collection('driver_profiles').doc(uid).update({
      'currentRouteId': routeId,
    });
  }

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

  Future<void> updateSeatStatus(
    String uid, bool isFull
  ) async {
    await _firestore.collection('driver_profiles').doc(uid).update({
      'isFull': isFull,
    });
  }

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
