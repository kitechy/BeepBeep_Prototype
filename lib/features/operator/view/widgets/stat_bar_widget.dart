import 'package:flutter/material.dart';

class StatBarWidget extends StatelessWidget {
  final int count;
  final String statName;
  final Color color;
  const StatBarWidget({
    super.key,
    required this.count,
    required this.statName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            color: color,
            fontSize: 22.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          statName,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13.5),
        ),
      ],
    );
  }
}
