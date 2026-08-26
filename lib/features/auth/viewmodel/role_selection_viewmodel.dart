import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:flutter/material.dart';

class RoleSelectionViewModel extends ChangeNotifier {

  // connection to the user repository
  final UserRepository _userRepo;
  RoleSelectionViewModel(this._userRepo);

  String? selectedRole;
  String? errorMessage;

  // selects a role
  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  // checks if a role is selected
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
