import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GoogleSigninButtonWidget extends StatelessWidget {
  const GoogleSigninButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });
  final VoidCallback? onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(0.8.sw, 75.h),
        backgroundColor: Color(0xffFFFFFF),
        foregroundColor: Color(0xff000000),
        side: BorderSide(color: Color(0xff0000FF), width: 1.w),
      ),
      child: isLoading
          ? SizedBox(
              height: 22.h,
              width: 22.w,
              child: const CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/google_logo.svg",
                  height: 0.06.sw,
                  width: 0.06.sw,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Continue with Google",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
