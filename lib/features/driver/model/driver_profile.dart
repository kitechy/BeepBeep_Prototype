import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfile {
  final String uid;
  final String phoneNumber;
  final String licenseNumber;
  final String address;
  final String status;
  final String? currentRouteId;
  final double? latitude;
  final double? longitude;

  DriverProfile({
    required this.uid,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.address,
    this.status = "offline",
    required this.currentRouteId,
    this.latitude,
    this.longitude,
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
      'latitude': latitude,
      'longitude': longitude,
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
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  DriverProfile copyWith({
    String? phoneNumber,
    String? licenseNumber,
    String? address,
    String? status,
    String? currentRouteId,
    double? latitude,
    double? longitude,
  }) {
    return DriverProfile(
      uid: uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      status: status ?? this.status,
      currentRouteId: currentRouteId ?? this.currentRouteId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
