import 'package:flutter/material.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';

class DriverPassengerCard extends StatelessWidget {
  final DriverProfile driver;
  final VoidCallback onClose;

  const DriverPassengerCard({
    super.key,
    required this.driver,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final availableSeats = driver.availableSeats;
    final totalSeats = driver.totalSeats;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: Color(0xff0057FF),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Jeepney',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1A17),
                  ),
                ),
              ),

              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_seat_rounded,
                size: 22,
                color: Color(0xff2E7D5B),
              ),

              const SizedBox(width: 8),

              Text(
                '$availableSeats',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff2E7D5B),
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                'seats available',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8A8378),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '${driver.occupiedSeats} occupied • $totalSeats total',
            style: const TextStyle(fontSize: 11.5, color: Color(0xff8A8378)),
          ),
        ],
      ),
    );
  }
}
