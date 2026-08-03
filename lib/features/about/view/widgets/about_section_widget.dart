import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutSectionWidget extends StatelessWidget {
  final String title;
  final String body;
  const AboutSectionWidget({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1570EF),
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF475467),
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}