import 'package:beepbeep_prototype/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoleContainerWidget extends StatelessWidget {
  const RoleContainerWidget({
    super.key,
    required this.text,
    required this.description,
    required this.svgPath,
    required this.bgColor,
    required this.borderColor,
    required this.roleTextColor,
    required this.roleDescriptionColor,
  });

  final String text;
  final String description;
  final String svgPath;
  final Color bgColor;
  final Color borderColor;
  final Color roleTextColor;
  final Color roleDescriptionColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Container(
      alignment: Alignment.center,
      width: screenWidth * 0.8,
      height: screenHeight * 0.15,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 3),
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: screenWidth * 0.2,
            height: screenHeight * 0.08,
          ),
          SizedBox(width: screenWidth * 0.1),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: text,
                color: roleTextColor,
                fontSize: 18 * screenWidth / 375,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: screenHeight * 0.001),
              TextWidget(
                text: description,
                color: roleDescriptionColor,
                fontSize: 10 * screenWidth / 375,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
