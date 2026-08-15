import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:flutter/material.dart';

class SeatStatusSheet extends StatelessWidget {
  final DriverProfile driver;

  const SeatStatusSheet({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF8F7F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────────────────
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE7E0D2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Status indicator ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: driver.isFull
                  ? const Color(0xffFFEBEE)
                  : const Color(0xffE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  driver.isFull
                      ? Icons.event_busy_rounded
                      : Icons.event_available_rounded,
                  color: driver.isFull
                      ? const Color(0xffD32F2F)
                      : const Color(0xff2E7D5B),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  driver.isFull ? 'Jeepney is Full' : 'Seats Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: driver.isFull
                        ? const Color(0xffD32F2F)
                        : const Color(0xff2E7D5B),
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