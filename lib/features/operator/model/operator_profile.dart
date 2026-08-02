import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorProfile {
  final String uid;
  final String phoneNumber;
  final String address;
  final String invCode;

  OperatorProfile({
    required this.uid,
    required this.phoneNumber,
    required this.address,
    required this.invCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'address': address,
      'invCode': invCode,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory OperatorProfile.fromMap(Map<String, dynamic> map) {
    return OperatorProfile(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      invCode: map['invCode'],
    );
  }

  OperatorProfile copyWith({
    String? displayName,
    String? phoneNumber,
    String? address,
    String? invCode,
  }) {
    return OperatorProfile(
      uid: uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      invCode: invCode ?? this.invCode,
    );
  }
}
