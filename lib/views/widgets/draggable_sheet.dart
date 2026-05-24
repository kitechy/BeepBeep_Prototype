import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DraggableSheet extends StatefulWidget {
  const DraggableSheet({super.key, required this.controller});
final DraggableScrollableController controller;
  @override
  State<DraggableSheet> createState() => _RoutesSelectionState();
}

class _RoutesSelectionState extends State<DraggableSheet> {
  

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: 0.4,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Center(
                    // Drag Handle
                    child: Container(
                      width: 40.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // TODO: Routes Selection
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
