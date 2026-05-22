import 'package:beepbeep_prototype/model/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser;

    final userName = user?.displayName ?? "User";

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Icon(Icons.person, size: 50.r, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            Divider(color: Colors.grey),
            SizedBox(height: 25.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              ),
              onPressed: _handleSignOut,
              child: Text(
                'Log Out',
                style: TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
