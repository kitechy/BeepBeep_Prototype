import 'package:beepbeep_prototype/model/auth_service.dart';
import 'package:beepbeep_prototype/views/pages/role_selection_screen.dart';
import 'package:flutter/material.dart';

class LoginController {
  /// Handles Google Sign-in and navigation
  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      await signInWithGoogle();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
    }
  }

  /// Handles guest login
  Future<void> handleGuestLogin(BuildContext context) async {
    try {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
