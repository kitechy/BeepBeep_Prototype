import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/auth_wrapper.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/view/widgets/google_signin_button.dart';
import 'package:beepbeep_prototype/features/auth/view/widgets/guest_button.dart';
import 'package:beepbeep_prototype/features/auth/viewmodel/login_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthRepository(AuthService())),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> with TickerProviderStateMixin {
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

  Future<void> _handleLogin() async {
    final loginVM = context.read<LoginViewModel>();

    final success = await loginVM.login();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            message:
                "Authentication Failed. Please check your credentials and try again.",
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = context.watch<LoginViewModel>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.w),
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
                    GoogleSigninButtonWidget(
                      onPressed: loginVM.isLoading ? null : _handleLogin,
                      isLoading: loginVM.isLoading,
                    ),

                    SizedBox(height: 0.02.sh),

                    GuestButtonWidget(
                      onPressed: () {
                        //TODO: Implement Guest logic
                      },
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
