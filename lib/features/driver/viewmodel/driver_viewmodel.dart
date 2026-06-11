import 'package:beepbeep_prototype/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  DriverViewModel(this._repo);

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
