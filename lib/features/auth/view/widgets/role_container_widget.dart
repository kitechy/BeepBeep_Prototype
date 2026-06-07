import 'package:beepbeep_prototype/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    required this.onTap,
    required this.isSelected,
  });

  final String text;
  final String description;
  final String svgPath;
  final Color bgColor;
  final Color borderColor;
  final Color roleTextColor;
  final Color roleDescriptionColor;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        width: 0.8.sw,
        height: 0.15.sh,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2.w),
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.3),
                    blurRadius: 8.r,
                    spreadRadius: 2.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, width: 0.2.sw, height: 0.08.sh),
            SizedBox(width: 0.1.sw),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: text,
                  color: roleTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 0.01.sh),
                TextWidget(
                  text: description,
                  color: roleDescriptionColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
