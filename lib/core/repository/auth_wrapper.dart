import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/commuter/view/commuter_home_page.dart';
import 'package:beepbeep_prototype/features/driver/view/driver_form.dart';
import 'package:beepbeep_prototype/features/driver/view/driver_home_page.dart';
import 'package:beepbeep_prototype/features/operator/view/operator_form.dart';
import 'package:beepbeep_prototype/features/operator/view/oprator_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return const LoginPage();
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const RoleSelectionPage();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            final role = data['role'];
            final isProfileComplete =
                data['profileCompleted'] as bool? ?? false;

            switch (role) {
              case 'commuter':
                return const CommuterHomePage();

              case 'driver':
                return isProfileComplete
                    ? const DriverHomePage()
                    : const DriverForm();

              case 'operator':
                return isProfileComplete
                    ? const OperatorHomePage()
                    : const OperatorForm();

              default:
                return const RoleSelectionPage();
            }
          },
        );
      },
    );
  }
}
