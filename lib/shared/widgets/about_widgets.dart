import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutNotice extends StatelessWidget {
  final String text;
  const AboutNotice({super.key, required this.text});

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

class AboutSection extends StatelessWidget {
  final String title;
  final String body;
  const AboutSection({super.key, required this.title, required this.body});

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

class AboutDivider extends StatelessWidget {
  const AboutDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Divider(height: 1.h, color: const Color(0xFFEAECF0)),
    );
  }
}

class AboutDataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tag;

  const AboutDataRow({
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
