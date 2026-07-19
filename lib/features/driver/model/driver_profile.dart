class DriverProfile {
  final String uid;
  final String phoneNumber;
  final String licenseNumber;
  final String address;
  final String status;

  DriverProfile({
    required this.uid,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.address,
    this.status = "offline",
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'contactNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'address': address,
      'status': status,
      'createdAt': DateTime.now(),
    };
  }

  factory DriverProfile.fromMap(Map<String, dynamic> map) {
    return DriverProfile(
      uid: map['uid'],
      phoneNumber: map['contactNumber'],
      licenseNumber: map['licenseNumber'],
      address: map['address'],
      status: map['status'],
    );
  }
}
