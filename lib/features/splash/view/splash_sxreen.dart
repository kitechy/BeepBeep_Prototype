
import 'package:beepbeep_prototype/features/splash/viewmodel/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = SplashController();
    _splashController.navigateToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo/BeepBeep_Logo.svg',
                width: 0.35.sw,
                height: 0.35.sw,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 0.04.sh),
              Text(
                'BeepBeep',
                style: GoogleFonts.montaguSlab(
                  fontSize: 40.sp,
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
