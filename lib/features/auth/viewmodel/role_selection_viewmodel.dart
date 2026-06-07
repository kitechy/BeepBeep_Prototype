import 'package:beepbeep_prototype/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';

class RoleSelectionViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  RoleSelectionViewModel(this._repo);
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
      await _repo.saveRole(role);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
