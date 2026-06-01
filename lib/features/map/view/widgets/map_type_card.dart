import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapTypeCard extends StatelessWidget {
  const MapTypeCard({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.selected,
  });
  final VoidCallback onTap;
  final String imageUrl;
  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(selected ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: selected
                  ? Border.all(color: Color(0xff0000FF), width: 3)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: selected ? Color(0xff0000FF) : Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }
}
