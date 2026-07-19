import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final DriverRepository _driverRepo;
  final UserRepository _userRepo;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();
  final addressController = TextEditingController();

  DriverViewModel(this._repo, this._driverRepo, this._userRepo);

  String? errorMessage;
  bool isLoading = false;
  bool _disposed = false;

  @override
  void dispose() {
    phoneController.dispose();
    licenseController.dispose();
    addressController.dispose();
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  User? get currentUser => _repo.currentUser;

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

  Future<bool> createDriverProfile() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final uid = _repo.currentUser?.uid;
    if (uid == null) {
      errorMessage = "User not logged in.";
      _safeNotify();
      return false;
    }

    final profile = DriverProfile(
      uid: uid,
      phoneNumber: phoneController.text.trim(),
      licenseNumber: licenseController.text.trim(),
      address: addressController.text.trim(),
    );

    isLoading = true;
    _safeNotify();

    try {
      await _driverRepo.createDriverProfile(profile);
      await _userRepo.setProfileCompleted(uid, true);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _safeNotify();
      return false;
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }
}
