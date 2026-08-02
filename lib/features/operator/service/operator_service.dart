import 'dart:math';

import 'package:beepbeep_prototype/features/operator/model/operator_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateUniqueCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    final code = List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return 'BBP-$code';
  }

  Future<void> createOperatorProfile(OperatorProfile profile) async {
    await _firestore
        .collection('operator_profiles')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  Future<OperatorProfile?> getOperatorProfile(String uid) async {
    final doc = await _firestore.collection('operator_profiles').doc(uid).get();

    if (!doc.exists) return null;

    return OperatorProfile.fromMap(doc.data()!);
  }

  Future<OperatorProfile?> getOperatorByCode(String code) async {
    final snapshot = await _firestore
        .collection('operator_profiles')
        .where('invCode', isEqualTo: code)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return OperatorProfile.fromMap(snapshot.docs.first.data());
  }
}
