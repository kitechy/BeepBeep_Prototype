import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final String currentUser;
  final String role;
  final String? photoURL;

  const DrawerHeaderWidget({
    required this.role,
    required this.currentUser,
    this.photoURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: photoURL != null
                ? ClipOval(child: Image.network(photoURL!, fit: BoxFit.cover))
                : ClipOval(
                    child: Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.account_circle,
                        size: 120.r,
                        color: Color(0xff0000FF),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1A17),
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  role.isNotEmpty
                      ? '${role[0].toUpperCase()}${role.substring(1)}'
                      : '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6B6966),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
