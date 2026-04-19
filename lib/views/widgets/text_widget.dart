import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    this.lineHeight = 1.5,
    this.color = Colors.black,
    this.fontWeight,
    this.decoration,
    this.textStyle,
  });

  final String text;
  final double fontSize;
  final double lineHeight;
  final Color color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style:
          textStyle ??
          TextStyle(
            fontSize: fontSize,
            height: lineHeight,
            color: color,
            fontWeight: fontWeight,
            decoration: decoration,
          ),
    );
  }
}
