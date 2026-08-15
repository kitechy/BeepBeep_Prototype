import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfile {
  final String uid;
  final String? operatorUid;
  final String phoneNumber;
  final String licenseNumber;
  final String address;
  final String status;
  final String? currentRouteId;
  final double? latitude;
  final double? longitude;
  final bool isFull;

  DriverProfile({
    required this.uid,
    this.operatorUid,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.address,
    this.status = "offline",
    required this.currentRouteId,
    this.latitude,
    this.longitude,
    this.isFull = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'operatorUid': operatorUid,
      'contactNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'address': address,
      'status': status,
      'currentRouteId': currentRouteId,
      'createdAt': FieldValue.serverTimestamp(),
      'latitude': latitude,
      'longitude': longitude,
      'isFull' : isFull,
    };
  }

  factory DriverProfile.fromMap(Map<String, dynamic> map) {
    return DriverProfile(
      uid: map['uid'],
      operatorUid: map['operatorUid'],
      phoneNumber: map['contactNumber'],
      licenseNumber: map['licenseNumber'],
      address: map['address'],
      status: map['status'],
      currentRouteId: map["currentRouteId"],
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      isFull: map['isFull'] ?? false,
    );
  }

  DriverProfile copyWith({
    String? operatorUid,
    String? phoneNumber,
    String? licenseNumber,
    String? address,
    String? status,
    String? currentRouteId,
    double? latitude,
    double? longitude,
    bool? isFull,
  }) {
    return DriverProfile(
      uid: uid,
      operatorUid: operatorUid ?? this.operatorUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      status: status ?? this.status,
      currentRouteId: currentRouteId ?? this.currentRouteId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFull: isFull ?? this.isFull,
    );
  }
}
