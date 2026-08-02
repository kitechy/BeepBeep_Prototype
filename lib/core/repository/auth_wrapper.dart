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

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            final role = data?['role'];
            final isProfileComplete = data?['profileCompleted'] == true;
        if (role == 'operator') {
          if (isProfileComplete) {
            return OperatorHomePage();
          } else {
            return OperatorForm();
          }
        }

            if (role == null) {
              return const RoleSelectionPage();
            }

            if (role == 'commuter') {
              return const CommuterHomePage();
            }

            if (role == 'driver') {
              if (isProfileComplete) {
                return DriverHomePage();
              } else {
                return DriverForm();
              }
            }

            if (role == 'operator') {
              return const OperatorHomePage();
            }

            return const LoginPage();
          },
        );
      },
    );
  }
}
