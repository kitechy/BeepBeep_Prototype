import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutDividerWidget extends StatelessWidget {
  const AboutDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Divider(height: 1.h, color: const Color(0xFFEAECF0)),
    );
  }
}