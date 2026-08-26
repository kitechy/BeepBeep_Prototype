import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String? email;
  final String? photoURL;
  final String role;
  final String? invCode;

  const ProfilePage({
    super.key,
    required this.name,
    this.email,
    this.photoURL,
    required this.role,
    this.invCode,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoURL != null && photoURL!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F7F4),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xff1C1A17),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff1C1A17)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xff0056FF),
              backgroundImage: hasPhoto ? NetworkImage(photoURL!) : null,
              child: hasPhoto
                  ? null
                  : Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            _InfoTile(label: 'Name', value: name),
            _InfoTile(label: 'Email', value: email ?? 'Not provided'),
            _InfoTile(label: 'Role', value: role),
            if (invCode != null)
              _InfoTile(label: 'Invitation Code', value: invCode!),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE0DED9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xff6B6966)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff1C1A17),
            ),
          ),
        ],
      ),
    );
  }
}
