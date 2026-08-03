import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LegalTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const LegalTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
      leading: Icon(icon, color: const Color(0xFF1570EF), size: 22.r),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.r),
      onTap: onTap,
    );
  }
}