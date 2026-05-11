import 'package:beepbeep_prototype/controller/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/role_selection_page.dart';
import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<LoginPage>
    with TickerProviderStateMixin {
  late final AnimationController _buttonController;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    );

    _buttonController.forward();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await signInWithGoogle();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.1.sh),
              Hero(
                tag: 'beepbeep-logo',
                child: SvgPicture.asset(
                  'assets/logo/BeepBeep_Logo.svg',
                  width: 0.5.sw,
                  height: 0.5.sw,
                ),
              ),
              SizedBox(height: 0.04.sh),
              Hero(
                tag: 'beepbeep-text',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    "BeepBeep",
                    style: GoogleFonts.montaguSlab(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0000FF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.15.sh),
              FadeTransition(
                opacity: _buttonFade,
                child: Column(
                  children: [
                    ElevatedButtonWidget(
                      svgPath: 'assets/icons/google_logo.svg',
                      iconHeight: 0.06.sw,
                      iconWidth: 0.06.sw,
                      text: 'Continue with Google',
                      bgColor: const Color(0xffFFFFFF),
                      textColor: const Color(0xff000000),
                      onPressed: _handleGoogleSignIn,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      width: 0.8.sw,
                      height: 0.15.sh,
                      borderColor: Color(0xff0000FF),
                    ),
                    SizedBox(height: 0.02.sh),
                    ElevatedButtonWidget(
                      icon: Icon(
                        Icons.person_rounded,
                        size: 0.06.sw,
                        color: Color(0xffFFFFFF),
                      ),
                      iconHeight: 0.06.sw,
                      iconWidth: 0.06.sw,
                      text: 'Continue as Guest',
                      bgColor: const Color(0xff0000FF),
                      textColor: const Color(0xffFFFFFF),
                      onPressed: () {},
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      width: 0.8.sw,
                      height: 0.15.sh,
                      borderColor: Color(0xff0000FF),
                    ),
                    SizedBox(height: 0.04.sh),
                    SizedBox(
                      width: 0.8.sw,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.6,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "By continuing, you are indicating that you accept our ",
                            ),
                            TextSpan(
                              text: "Terms of Service",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
