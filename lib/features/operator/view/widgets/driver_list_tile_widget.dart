import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:flutter/material.dart';

class DriverListTile extends StatelessWidget {
  final DriverProfile driver;
  final VoidCallback onTap;

  final String? driverName;
  final String? routeName;

  const DriverListTile({
    super.key,
    required this.driver,
    required this.onTap,
    this.driverName,
    this.routeName,
  });

  bool get isOnline => driver.status == 'online';

  String get displayName {
    if (driverName != null && driverName!.trim().isNotEmpty) {
      return driverName!.trim();
    }

    return 'Driver';
  }

  bool get hasRoute {
    return routeName != null && routeName!.trim().isNotEmpty;
  }

  String get displayRoute {
    if (hasRoute) {
      return routeName!.trim();
    }

    return 'No route';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status indicator
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline
                        ? const Color(0xff5FC18B)
                        : Colors.transparent,
                    border: Border.all(
                      color: isOnline
                          ? const Color(0xff5FC18B)
                          : const Color(0xffB65B45),
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 13),

              // Driver information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driver name
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xffF0ECE5),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Route name
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hasRoute
                            ? const Color(0xffE5AE3B)
                            : const Color(0xff3A3731),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        displayRoute,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasRoute
                              ? const Color(0xff17130E)
                              : const Color(0xffBEB7AD),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                                        // License number
                    Text(
                      driver.licenseNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff9B958B),
                        fontSize: 12,
                      ),
                    ),

                    // ADD THIS ↓
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.people_alt_rounded,
                          size: 13,
                          color: Color(0xff5FC18B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${driver.totalPassengers} passengers',
                          style: const TextStyle(
                            color: Color(0xff5FC18B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Live / offline
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  isOnline ? 'LIVE' : 'OFFLINE',
                  style: TextStyle(
                    color: isOnline
                        ? const Color(0xffE0D9CD)
                        : const Color(0xff9B958B),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}