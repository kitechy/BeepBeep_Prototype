import 'package:beepbeep_prototype/views/widgets/elevatedbtn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Routes extends StatelessWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: Color(0xff0000FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButtonWidget(
              text: 'San Francisco',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              width: 1.sw,
              height: 0.08.sh,
              borderColor: Color(0xffffffff),
            ),
            SizedBox(height: 18.h),
            ElevatedButtonWidget(
              text: 'Banquerohan',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              width: 1.sw,
              height: 0.08.sh,
              borderColor: Color(0xfffffffff),
            ),
            SizedBox(height: 18.h),
            ElevatedButtonWidget(
              text: 'Buenavista',
              bgColor: Color(0xffFFFFFF),
              textColor: Color(0xff000000),
              onPressed: () {},
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              width: 1.sw,
              height: 0.08.sh,
              borderColor: Color(0xff0000FF),
            ),
          ],
        ),
      ),
    );
  }
}
