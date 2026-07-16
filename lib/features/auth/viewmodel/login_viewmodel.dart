import 'package:beepbeep_prototype/core/repository/auth_repository.dart';

import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  LoginViewModel(this._repo);

  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<bool> login() async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotify();

      await _repo.signIn();

      return true;
    } catch (e) {
      errorMessage =
          "Authentication Failed. Please check your credentials and try again.";
      return false;
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }


  Future<void> logout() async {
    try {
      await _repo.signOut();
    } catch (e) {
      errorMessage = "Logout Failed. Please try again.";
      _safeNotify();
    }
  }
}

/// TODO: Handles guest login
//   Future<void> handleGuestLogin(BuildContext context) async {
//     try {
//       if (!context.mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
//       );
//     } catch (e) {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
// }
