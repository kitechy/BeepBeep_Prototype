import 'package:beepbeep_prototype/features/auth/viewmodel/role_selection_viewmodel.dart';
import 'package:beepbeep_prototype/shared/widgets/elevatedbtn_widget.dart';
import 'package:beepbeep_prototype/features/auth/view/widgets/role_container_widget.dart';
import 'package:beepbeep_prototype/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  late RoleSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoleSelectionController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.01.sh),
            TextWidget(
              text: 'Select Your Role',
              textStyle: GoogleFonts.montaguSlab(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
              fontSize: 24.sp,
            ),
            SizedBox(height: 0.08.sh),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.selectRole("Commuter");
                });
              },
              child: RoleContainerWidget(
                borderColor: _controller.getSelectedRole() == "Commuter"
                    ? Color(0xff0000FF)
                    : Colors.grey,
                bgColor: Color(0xffFFFFFF),
                text: 'Commuter',
                roleTextColor: Color(0xff000000),
                description: "I'm looking for a ride.",
                roleDescriptionColor: Color(0xff000000),
                svgPath: 'assets/images/Commuter.svg',
              ),
            ),
            SizedBox(height: 0.03.sh),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.selectRole("Driver");
                });
              },
              child: RoleContainerWidget(
                borderColor: _controller.getSelectedRole() == "Driver"
                    ? Color(0xff0000FF)
                    : Colors.grey,
                bgColor: Color(0xffFFFFFF),
                text: 'Driver',
                roleTextColor: Color(0xff000000),
                description: 'I offer a ride.',
                roleDescriptionColor: Color(0xff000000),
                svgPath: 'assets/images/Driver.svg',
              ),
            ),
            SizedBox(height: 0.03.sh),
            TextWidget(
              text: 'Or',
              textStyle: GoogleFonts.montaguSlab(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              fontSize: 24.sp,
            ),
            SizedBox(height: 0.03.sh),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.selectRole("Operator");
                });
              },
              child: RoleContainerWidget(
                borderColor: _controller.getSelectedRole() == "Operator"
                    ? Color(0xff0000FF)
                    : Colors.grey,
                bgColor: Color(0xffFFFFFF),
                text: 'Operator',
                roleTextColor: Color(0xff000000),
                description: 'I monitor rides.',
                roleDescriptionColor: Color(0xff000000),
                svgPath: 'assets/images/Operator.svg',
              ),
            ),
            SizedBox(height: 0.05.sh),
            ElevatedButtonWidget(
              text: 'Continue',
              bgColor: Color(0xff0000FF),
              textColor: Color(0xffFFFFFF),
              onPressed: () {
                _controller.handleContinue(context);
              },
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              iconWidth: null,
              iconHeight: null,
              borderColor: Color(0xff0000FF),
            ),
          ],
        ),
      ),
    );
  }
}
