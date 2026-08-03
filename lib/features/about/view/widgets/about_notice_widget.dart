import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutNoticeWidget extends StatelessWidget {
  final String text;
  const AboutNoticeWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8FF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFB2DDFF), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF1849A9),
          height: 1.6,
        ),
      ),
    );
  }
}