import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/features/operator/model/operator_profile.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OperatorFormViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final OperatorRepository _operatorRepo;
  final UserRepository _userRepo;

  OperatorFormViewModel(this._repo, this._operatorRepo, this._userRepo);

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;
  bool _disposed = false;

  @override
  void dispose() {
    phoneController.dispose();
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

  Future<bool> createOperatorProfile() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final uid = _repo.currentUser?.uid;
    if (uid == null) {
      errorMessage = "User not logged in.";
      _safeNotify();
      return false;
    }

    final code = await _operatorRepo.generateCode();

    final profile = OperatorProfile(
      uid: uid,
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      invCode: code,
    );

    isLoading = true;
    _safeNotify();

    try {
      await _operatorRepo.createOperatorProfile(profile);
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
