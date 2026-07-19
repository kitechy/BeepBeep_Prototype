import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DriverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<void> createDriverProfile(
      DriverProfile profile,
  ) async {
    await _firestore
        .collection('driver_profiles')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  
  Future<DriverProfile?> getDriverProfile(
      String uid,
  ) async {
    final doc = await _firestore
        .collection('driver_profiles')
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return DriverProfile.fromMap(doc.data()!);
  }

  
  Future<void> updateDriverProfile(
      DriverProfile profile,
  ) async {
    await _firestore
        .collection('driver_profiles')
        .doc(profile.uid)
        .update(profile.toMap());
  }
}