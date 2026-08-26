import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/features/commuter/model/jeepney_arrival_estimate.dart';

import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:flutter/material.dart';

class DriverPassengerCard extends StatelessWidget {
  final DriverProfile driver;
  final UserModel? user;
  final JeepneyArrivalEstimate? arrivalEstimate;
  final VoidCallback onClose;

  const DriverPassengerCard({
    super.key,
    required this.driver,
    this.user,
    this.arrivalEstimate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final name = user?.name?.trim();

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jeepney',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1C1A17),
                      ),
                    ),
                    Text(
                      name == null || name.isEmpty ? 'Driver' : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff8A8378),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'License',
            value: driver.licenseNumber,
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: driver.phoneNumber,
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: driver.address,
          ),
          const SizedBox(height: 14),
          if (arrivalEstimate != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: Color(0xff0057FF),
                ),
                const SizedBox(width: 8),
                Text(
                  '${arrivalEstimate!.minutes} min away',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0057FF),
                  ),
                ),
                const Spacer(),
                Text(
                  '${arrivalEstimate!.distanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff8A8378),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
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
                '${driver.availableSeats}',
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
            '${driver.occupiedSeats} occupied • ${driver.totalSeats} total',
            style: const TextStyle(fontSize: 11.5, color: Color(0xff8A8378)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xff0057FF)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xff4F4A43)),
          ),
        ),
      ],
    );
  }
}
