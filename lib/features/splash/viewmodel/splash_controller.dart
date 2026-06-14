import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:flutter/material.dart';

class SplashController {

  Future<void> navigateToLogin(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
