import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Color(0xff0000FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButtonWidget(
              text: 'San Francisco',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24,
              fontWeight: FontWeight.normal,
              width: screenWidth * 1,
              height: screenHeight * 0.08,
            ),
            const SizedBox(height: 18),
            ElevatedButtonWidget(
              text: 'Banquerohan',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24,
              fontWeight: FontWeight.normal,
              width: screenWidth * 1,
              height: screenHeight * 0.08,
            ),
            const SizedBox(height: 18),
            ElevatedButtonWidget(
              text: 'Buenavista',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24,
              fontWeight: FontWeight.normal,
              width: screenWidth * 1,
              height: screenHeight * 0.08,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
