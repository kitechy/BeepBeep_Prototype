import 'package:beepbeep_prototype/model/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Handles user sign out
  Future<void> handleSignOut(BuildContext context) async {
    try {
      await signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }
}
