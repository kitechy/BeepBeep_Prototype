import 'package:beepbeep_prototype/features/commuter/view/commuter_home_page.dart';
import 'package:flutter/material.dart';

class RoleSelectionController {
  String selectedRole = "";

  /// Updates the selected role
  void selectRole(String role) {
    selectedRole = role;
  }

  /// Gets the current selected role
  String getSelectedRole() {
    return selectedRole;
  }

  /// Validates if a role is selected
  bool isRoleSelected() {
    return selectedRole.isNotEmpty;
  }

  /// Handles navigation based on the selected role
  void handleContinue(BuildContext context) {
    if (!isRoleSelected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role to continue')),
      );
      return;
    }

    // Navigate based on selected role
    switch (selectedRole) {
      case "Commuter":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CommuterHomePage()),
        );
        break;
      case "Driver":
        // TODO: Navigate to Driver home page
        break;
      case "Operator":
        // TODO: Navigate to Operator home page
        break;
      default:
        break;
    }
  }

  /// Resets the selected role
  void resetRole() {
    selectedRole = "";
  }
}
