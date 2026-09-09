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

  final int totalSeats;
  final int occupiedSeats;

  final int totalPassengerCount;
  final String? passengerCountDate;

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
    required this.totalSeats,
    this.occupiedSeats = 0,
    this.totalPassengerCount = 0,
    this.passengerCountDate,
  });

  int get availableSeats {
    final available = totalSeats - occupiedSeats;
    return available < 0 ? 0 : available;
  }

  bool get isFull {
    return occupiedSeats >= totalSeats;
  }

  String get seatStatus {
    if (occupiedSeats >= totalSeats) {
      return "full";
    }

    return 'available';
  }

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
      'totalSeats': totalSeats,
      'occupiedSeats': occupiedSeats,
      'totalPassengerCount': totalPassengerCount,
      'passengerCountDate': passengerCountDate,
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
      totalSeats: (map['totalSeats'] as num?)?.toInt() ?? 0,
      occupiedSeats: (map['occupiedSeats'] as num?)?.toInt() ?? 0,
      totalPassengerCount: (map['totalPassengerCount'] as num?)?.toInt() ?? 0,
      passengerCountDate: map['passengerCountDate'],
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
    int? totalSeats,
    int? occupiedSeats,
    int? totalPassengerCount,
    String? passengerCountDate,
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
      totalSeats: totalSeats ?? this.totalSeats,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
      totalPassengerCount: totalPassengerCount ?? this.totalPassengerCount,
      passengerCountDate: passengerCountDate ?? this.passengerCountDate,
    );
  }
}
