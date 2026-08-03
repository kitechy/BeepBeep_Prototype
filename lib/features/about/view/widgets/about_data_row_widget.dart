import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutDataRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tag;

  const AboutDataRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: const Color(0xFF1570EF)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
            ),
          ),
          Text(
            tag,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}