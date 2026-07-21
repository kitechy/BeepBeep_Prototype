import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final bool isOnline;
  final AnimationController c;
  const StatusDot({super.key, required this.isOnline, required this.c});

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const CircleAvatar(radius: 5, backgroundColor: Color(0xff8A8378));
    }
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(c),
      child: const CircleAvatar(radius: 5, backgroundColor: Color(0xff2E7D5B)),
    );
  }
}
