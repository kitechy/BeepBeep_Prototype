import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/features/auth/viewmodel/role_selection_viewmodel.dart';
import 'package:beepbeep_prototype/features/commuter/view/commuter_home_page.dart';
import 'package:beepbeep_prototype/features/driver/view/driver_form.dart';
import 'package:beepbeep_prototype/features/operator/view/oprator_home_page.dart';
import 'package:beepbeep_prototype/shared/widgets/elevatedbtn_widget.dart';
import 'package:beepbeep_prototype/features/auth/view/widgets/role_container_widget.dart';
import 'package:beepbeep_prototype/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleSelectionViewModel(context.read<AuthRepository>()),
      child: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatelessWidget {
  const _RoleSelectionView();

  @override
  Widget build(BuildContext context) {
    final roleVM = context.watch<RoleSelectionViewModel>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Column(
                children: [
                  TextWidget(
                    text: 'Select Your Role',
                    textStyle: GoogleFonts.montaguSlab(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    fontSize: 24.sp,
                  ),
                  TextWidget(
                    text: "Choose how you'll use BeepBeep",
                    fontSize: 13.sp,
                  ),
                ],
              ),
            ),

            SizedBox(height: 0.04.sh),

            RoleContainerWidget(
              text: 'Commuter',
              description: "I'm looking for a ride.",
              svgPath: 'assets/images/Commuter.svg',
              bgColor: Colors.white,
              borderColor: roleVM.isSelected("commuter")
                  ? const Color(0xff0000FF)
                  : Colors.grey,
              roleTextColor: Colors.black,
              roleDescriptionColor: Colors.black,
              isSelected: roleVM.isSelected("commuter"),
              onTap: () {
                roleVM.selectRole("commuter");
              },
            ),

            SizedBox(height: 0.03.sh),

            RoleContainerWidget(
              text: 'Driver',
              description: 'I offer a ride.',
              svgPath: 'assets/images/Driver.svg',
              bgColor: Colors.white,
              borderColor: roleVM.isSelected("driver")
                  ? const Color(0xff0000FF)
                  : Colors.grey,
              roleTextColor: Colors.black,
              roleDescriptionColor: Colors.black,
              isSelected: roleVM.isSelected("driver"),
              onTap: () {
                roleVM.selectRole("driver");
              },
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

            RoleContainerWidget(
              text: 'Operator',
              description: 'I monitor rides.',
              svgPath: 'assets/images/Operator.svg',
              bgColor: Colors.white,
              borderColor: roleVM.isSelected("operator")
                  ? const Color(0xff0000FF)
                  : Colors.grey,
              roleTextColor: Colors.black,
              roleDescriptionColor: Colors.black,
              isSelected: roleVM.isSelected("operator"),
              onTap: () {
                roleVM.selectRole("operator");
              },
            ),

            SizedBox(height: 0.05.sh),

            ElevatedButtonWidget(
              text: 'Continue',
              bgColor: const Color(0xff0000FF),
              textColor: Colors.white,
              borderColor: const Color(0xff0000FF),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              iconWidth: null,
              iconHeight: null,
              onPressed: () async {
                if (roleVM.selectedRole == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a role to continue."),
                    ),
                  );
                  return;
                }
                try {
                  await roleVM.saveRole(roleVM.selectedRole!);
                  if (!context.mounted) return;

                  if (roleVM.selectedRole == "commuter") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommuterHomePage(),
                      ),
                    );
                  }

                  if (roleVM.selectedRole == "driver") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverForm(),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }

                if (roleVM.selectedRole == "operator") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OperatorForm(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
