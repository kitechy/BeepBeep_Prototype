import 'package:beepbeep_prototype/controller/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/login_page.dart';
import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<void> _handleSignOut() async {
    try {
      await signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-Out failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 0.3.sh,
            decoration: BoxDecoration(color: Color(0xff0000FF)),
            child: Center(
              child: Stack(
                children: [
                  Text(
                    'Kevin Perez',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          ElevatedButtonWidget(
            text: 'Log out',
            bgColor: Colors.red,
            textColor: Color(0xffFFFFFF),
            onPressed: _handleSignOut,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            width: 0.7.sw,
            height: 50.h,
            borderColor: Color(0xff0000FF),
          ),
        ],
      ),
    );
  }
}
