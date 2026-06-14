import 'package:flutter/material.dart';

class ChangeRoleButton extends StatelessWidget {
  const ChangeRoleButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(Icons.swap_horiz_outlined, size: 24),
    );
  }
}
