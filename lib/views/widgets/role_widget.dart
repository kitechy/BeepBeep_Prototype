import 'package:beepbeep_prototype/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class RoleWidget extends StatelessWidget {
  const RoleWidget({
    super.key,
    required this.text,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });
  final String text;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff000000)),
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Image.asset(
                imagePath,
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
              ),
              SizedBox(height: screenHeight * 0.01),
              TextWidget(
                text: text,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000),
              ),
              Divider(
                color: const Color(0xff000000),
                thickness: 1,
                indent: screenWidth * 0.12,
                endIndent: screenWidth * 0.12,
              ),
              TextWidget(
                text: description,
                fontSize: screenWidth * 0.02,
                color: const Color(0xff000000),
              ),
              SizedBox(height: screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
