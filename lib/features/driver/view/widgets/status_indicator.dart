import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final String greeting;
  final String? route;
  final String driverName;

  const StatusIndicator({
    super.key,
    required this.isOnline,

    required this.greeting,
    this.route,
    required this.driverName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  greeting + ", " + driverName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1C1A17),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  route == null ? "No route selected" : "📍 $route",
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: route == null
                        ? FontStyle.italic
                        : FontStyle.normal,
                    color: route == null
                        ? const Color(0xff8A8378)
                        : const Color(0xffC7952F),
                    fontWeight: route == null
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? Color(0xff2E7D5B) : Color(0xff8A8378),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                isOnline ? "Online" : "Offline",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isOnline ? Color(0xff2E7D5B) : Color(0xff8A8378),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
