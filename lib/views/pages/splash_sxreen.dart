import 'package:beepbeep_prototype/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo/BeepBeep_Logo.svg',
                width: screenWidth * 0.35,
                height: screenWidth * 0.35,
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                'BeepBeep',
                style: GoogleFonts.montaguSlab(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0000FF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
