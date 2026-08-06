import 'dart:math';
import 'package:flutter/material.dart';

class CompassWidget extends StatelessWidget {
  final Stream<double> bearingStream;
  final double initialBearing;
  final VoidCallback onTap;

  const CompassWidget({
    super.key,
    required this.bearingStream,
    required this.initialBearing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: bearingStream,
      initialData: initialBearing,
      builder: (context, snapshot) {
        final bearing = snapshot.data ?? 0;

        if (bearing == 0) return const SizedBox.shrink();

        return Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 3,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Transform.rotate(
                angle: -(bearing * pi / 180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // ── Red top (north) ──────────────────────────────────
                    Icon(
                      Icons.navigation_rounded,
                      size: 18,
                      color: Color(0xffD32F2F),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}