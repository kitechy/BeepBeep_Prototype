import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: Color(0xff0000FF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              );
            }
            return const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            );
          }),
        ),
        child: NavigationBar(
          backgroundColor: Color(0xffFFFFFF),
          indicatorColor: Colors.transparent,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined, size: 24.r),
              selectedIcon: Icon(
                Icons.location_on,
                size: 24.r,
                color: Color(0xff0000FF),
              ),
              label: 'Track',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined, size: 24.r),
              selectedIcon: Icon(
                Icons.account_circle,
                size: 24.r,
                color: Color(0xff0000FF),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
