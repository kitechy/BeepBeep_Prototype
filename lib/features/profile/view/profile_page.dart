import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/features/auth/view/role_selection_page.dart';
import 'package:beepbeep_prototype/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(AuthRepository(AuthService())),
      child: _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => __ProfileViewState();
}

class __ProfileViewState extends State<_ProfileView> {
  Future<void> signOut() async {
    final driverVM = context.read<ProfileViewModel>();

    final success = await driverVM.logout();

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
            message: "Log out failed. Please try again later.",
          );
        },
      );
    }
  }

  void changeRole() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileVM.currentUser == null
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
                    child: profileVM.currentUser!.photoURL != null
                        ? ClipOval(
                            child: Image.network(
                              profileVM.currentUser!.photoURL!,
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
                    profileVM.currentUser!.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // User Email
                  Text(
                    profileVM.currentUser!.email ?? '',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 40.h),
                  // Logout Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signOut,
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
                  ElevatedButton(
                    onPressed: changeRole,
                    child: Icon(Icons.swap_horiz_outlined, size: 24),
                  ),
                ],
              ),
            ),
    );
  }
}
