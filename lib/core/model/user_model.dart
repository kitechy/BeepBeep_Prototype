class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? photoURL;
  final String role;
  final bool profileComplete;

  const UserModel({
    required this.uid,
    this.name,
    this.email,
    this.photoURL,
    required this.role,
    this.profileComplete = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      photoURL: (map['photoURL'] ?? map['photoUrl']) as String?,
      role: map['role'] as String,
      profileComplete: map['profileComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'role': role,
      'profileComplete': profileComplete,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoURL,
    String? role,
    bool? profileComplete,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }
}
