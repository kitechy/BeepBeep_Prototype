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
  });

  final String text;
  final double fontSize;
  final double lineHeight;
  final Color color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
