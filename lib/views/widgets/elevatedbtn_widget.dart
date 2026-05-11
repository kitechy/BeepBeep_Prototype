import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    required this.fontSize,
    required this.fontWeight,
    this.iconWidth,
    this.iconHeight,
    this.svgPath,
    this.icon,
    required this.borderColor,
    this.iconColor,
  });
  final String text;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  final double? iconWidth;
  final double? iconHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final String? svgPath;
  final Icon? icon;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 75.h),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        side: BorderSide(color: borderColor, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgPath != null && icon == null) ...[
            SvgPicture.asset(svgPath!, width: iconWidth, height: iconHeight),
            SizedBox(width: 20.w),
          ],
          if (icon != null) ...[icon!, SizedBox(width: 20.w)],
          Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }
}
