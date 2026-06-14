import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:flutter/material.dart';

class RoleService {
  void goToRoleSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
    );
  }
}
