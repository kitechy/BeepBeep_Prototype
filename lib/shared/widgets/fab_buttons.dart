import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FabButtonWidget extends StatelessWidget {
  const FabButtonWidget({
    super.key,
    required this.onPressed,
    required this.heroTag,
    required this.icon,
  });
  final VoidCallback onPressed;
  final String heroTag;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: heroTag,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      backgroundColor: Color(0xffFFFFFF),
      child: Icon(icon, color: Color(0xff0000FF), size: 24.r),
    );
  }
}
