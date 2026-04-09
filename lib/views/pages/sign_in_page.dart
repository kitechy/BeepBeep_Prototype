import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninPage>
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
              Hero(
                tag: 'beepbeep-logo',
                child: SvgPicture.asset(
                  'assets/logo/BeepBeep_Logo.svg',
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Hero(
                tag: 'beepbeep-text',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    "BeepBeep",
                    style: GoogleFonts.montaguSlab(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0000FF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.12),
              FadeTransition(
                opacity: _buttonFade,
                child: Column(
                  children: [
                    ElevatedButtonWidget(
                      svgPath: 'assets/icons/google_logo.svg',
                      iconHeight: screenWidth * 0.06,
                      iconWidth: screenWidth * 0.06,
                      text: 'Continue with Google',
                      bgColor: const Color(0xffFFFFFF),
                      textColor: const Color(0xff000000),
                      onPressed: () {},
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButtonWidget(
                      icon: Icon(
                        Icons.person_rounded,
                        size: screenWidth * 0.06,
                        color: Colors.black,
                      ),
                      iconHeight: screenWidth * 0.06,
                      iconWidth: screenWidth * 0.06,
                      text: 'Continue as Guest',
                      bgColor: const Color(0xffFFFFFF),
                      textColor: const Color(0xff000000),
                      onPressed: () {},
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
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
