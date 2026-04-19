import 'package:beepbeep_prototype/views/pages/commuter_home_page.dart';
import 'package:beepbeep_prototype/views/widgets/role_container_widget.dart';
import 'package:beepbeep_prototype/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: 'Select Your Role',
                textStyle: GoogleFonts.montaguSlab(
                  fontSize: 24 * screenWidth / 375,
                  fontWeight: FontWeight.w600,
                ),
                fontSize: 24 * screenWidth / 375,
              ),
              SizedBox(height: screenHeight * 0.08),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommuterHomePage(),
                    ),
                  );
                },
                child: RoleContainerWidget(
                  borderColor: Color(0xff000000),
                  bgColor: Color(0xffFFFFFF),
                  text: 'Commuter',
                  roleTextColor: Color(0xff000000),
                  description: 'I want to look for rides.',
                  roleDescriptionColor: Color(0xff000000),
                  svgPath: 'assets/images/Commuter.svg',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              RoleContainerWidget(
                borderColor: Color(0xff000000),
                bgColor: Color(0xffFFFFFF),
                text: 'Driver',
                roleTextColor: Color(0xff000000),
                description: 'I offer a ride.',
                roleDescriptionColor: Color(0xff000000),
                svgPath: 'assets/images/Driver.svg',
              ),
              SizedBox(height: screenHeight * 0.03),
              TextWidget(
                text: 'Or are you an',
                textStyle: GoogleFonts.montaguSlab(
                  fontSize: 18 * screenWidth / 375,
                  fontWeight: FontWeight.w500,
                ),
                fontSize: 24 * screenWidth / 375,
              ),
              SizedBox(height: screenHeight * 0.03),
              RoleContainerWidget(
                borderColor: Color(0xff000000),
                bgColor: Color(0xffFFFFFF),
                text: 'Operator',
                roleTextColor: Color(0xff000000),
                description: 'I monitor rides.',
                roleDescriptionColor: Color(0xff000000),
                svgPath: 'assets/images/Operator.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
