import 'package:flutter/material.dart';
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
    required this.width,
    required this.height,
    required this.iconWidth,
    required this.iconHeight,
    this.svgPath,
    this.icon,
  });
  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final String? svgPath;
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgPath != null && icon == null) ...[
              SvgPicture.asset(svgPath!, width: iconWidth, height: iconHeight),
              const SizedBox(width: 20),
            ],
            if (icon != null) ...[icon!, const SizedBox(width: 20)],
            Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
            ),
          ],
        ),
      ),
    );
  }
}
