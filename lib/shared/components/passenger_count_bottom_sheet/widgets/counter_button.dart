import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CounterButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: enabled ? const Color(0xffF2F4F8) : const Color(0xffEEEEEE),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Icon(
            icon,
            size: 22,
            color: enabled ? const Color(0xff1C1A17) : const Color(0xffB8B5B0),
          ),
        ),
      ),
    );
  }
}
