import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  ProfileViewModel(this._repo);

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

  User? get currentUser {
    return _repo.currentUser;
  }

  Future<bool> logout() async {
    try {
      await _repo.signOut();
      return true;
    } catch (e) {
      errorMessage = "Logout Failed. Please try again.";
      _safeNotify();
      return false;
    }
  }
}
