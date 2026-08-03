import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:flutter/material.dart';

class RoleSelectionViewModel extends ChangeNotifier {
  final UserRepository _userRepo;

  RoleSelectionViewModel(this._userRepo);
  String? selectedRole;
  String? errorMessage;

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  bool isSelected(String role) {
    return selectedRole == role;
  }

  Future<void> saveRole(String role) async {
    try {
      await _userRepo.saveRole(role);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
