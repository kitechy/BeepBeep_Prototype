import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuestButtonWidget extends StatelessWidget {
  const GuestButtonWidget({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 75.h),
        backgroundColor: Color(0xff0000FF),
        foregroundColor: Color(0xffFFFFFF),
        side: BorderSide(color: Color(0xff0000FF), width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_rounded, size: 0.06.sw),
          SizedBox(width: 10.w),
          Text(
            "Continue as Guest",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
