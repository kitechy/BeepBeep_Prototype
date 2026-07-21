import 'package:beepbeep_prototype/features/driver/view/widgets/status_dot.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onPressed;
  final AnimationController c;
  const StatusIndicator({
    super.key,
    required this.isOnline,
    required this.onPressed,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatusDot(isOnline: isOnline, c: c),
        const SizedBox(width: 9),
        Text(
          isOnline ? "ONLINE" : "OFFLINE",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: isOnline ? Color(0xff2E7D5B) : Color(0xff8A8378),
          ),
        ),
      ],
    );
  }
}
