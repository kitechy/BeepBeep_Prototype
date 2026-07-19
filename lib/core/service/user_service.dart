import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setProfileCompleted(String uid, bool value) async {
    await _firestore.collection('users').doc(uid).update({
      'profileCompleted': value,
    });
  }
}
