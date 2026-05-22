import 'package:beepbeep_prototype/model/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  Future<void> _handleSignOut() async {
    try {
      await signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  // Profile Image
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff0000FF), width: 2.r),
                    ),
                    child: _currentUser!.photoURL != null
                        ? ClipOval(
                            child: Image.network(
                              _currentUser!.photoURL!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.account_circle,
                                size: 120.r,
                                color: Color(0xff0000FF),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 20.h),
                  // User Name
                  Text(
                    _currentUser!.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // User Email
                  Text(
                    _currentUser!.email ?? '',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 40.h),
                  // Logout Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSignOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0000FF),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
    );
  }
}
