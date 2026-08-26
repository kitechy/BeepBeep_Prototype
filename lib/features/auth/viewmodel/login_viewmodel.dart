import 'package:beepbeep_prototype/core/repository/auth_repository.dart';

import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // connection to the auth repository
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

  // send login req to auth repository
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

  Future<bool> guestLogin() async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotify();

      await _repo.signInAsGuest();

      return true;
    } catch (e) {
      errorMessage = "Unable to continue as guest.";
      return false;
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }
}
