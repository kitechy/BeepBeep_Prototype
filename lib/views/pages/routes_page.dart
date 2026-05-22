import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4.h,
      minChildSize: 0.1.h,
      maxChildSize: 0.4.h,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 25.h),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                  Container(
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          margin: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            color: Color(0xff0000FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Banquerohan',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
