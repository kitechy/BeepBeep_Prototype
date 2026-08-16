import 'package:beepbeep_prototype/features/operator/view/widgets/stat_bar_widget.dart';
import 'package:flutter/material.dart';

class StatusBarWidget extends StatelessWidget {
  final int fleetCount;
  final int onlineD;
  final int offlineD;
  const StatusBarWidget({
    super.key,
    required this.fleetCount,
    required this.onlineD,
    required this.offlineD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff181813).withOpacity(0.80),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xffE7E0D2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(12),
              child: Text(
                "DISPATCH",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),

          StatBarWidget(
            count: fleetCount,
            statName: "FLEET",
            color: Color(0xffFFFFFF),
          ),
          StatBarWidget(
            count: onlineD,
            statName: "ONLINE",
            color: Color(0xff5fa876),
          ),
          StatBarWidget(
            count: offlineD,
            statName: "OFFLINE",
            color: Color(0xffc2684a),
          ),
        ],
      ),
    );
  }
}
