import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GreetingCard extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final String greeting;
  const GreetingCard({
    super.key,
    required this.name,
    this.photoUrl,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xffE7E0D2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting + " 👋",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1C1A17),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Driver',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Color(0xff0000FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: photoUrl != null
                  ? ClipOval(child: Image.network(photoUrl!, fit: BoxFit.cover))
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
          ],
        ),
      ),
    );
  }
}
