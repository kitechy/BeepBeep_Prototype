import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfile {
  final String uid;
  final String phoneNumber;
  final String licenseNumber;
  final String address;
  final String status;
  final String? currentRouteId;

  DriverProfile({
    required this.uid,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.address,
    this.status = "offline",
    required this.currentRouteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'contactNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'address': address,
      'status': status,
      'currentRouteId': currentRouteId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory DriverProfile.fromMap(Map<String, dynamic> map) {
    return DriverProfile(
      uid: map['uid'],
      phoneNumber: map['contactNumber'],
      licenseNumber: map['licenseNumber'],
      address: map['address'],
      status: map['status'],
      currentRouteId: map["currentRouteId"],
    );
  }

  DriverProfile copyWith({
    String? phoneNumber,
    String? licenseNumber,
    String? address,
    String? status,
    String? currentRouteId
  }) {
    return DriverProfile(
      uid: uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      status: status ?? this.status, currentRouteId: currentRouteId ?? this.currentRouteId,
      
    );
  }
}
