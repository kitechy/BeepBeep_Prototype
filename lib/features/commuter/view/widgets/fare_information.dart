import 'package:flutter/material.dart';

class FareInformationDialog extends StatelessWidget {
  const FareInformationDialog({super.key});

  static const List<Map<String, dynamic>> fares = [
    {'route': 'Banquerohan', 'regular': 13.00, 'discounted': 10.40},
    {'route': 'San Francisco', 'regular': 13.00, 'discounted': 10.40},
    {'route': 'Buenavista', 'regular': 50.00, 'discounted': 40.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: Color(0xff0000FF),
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Fare Guide',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C1A17),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff777777),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Text(
              'Estimated jeepney fares from SM Terminal, Legazpi City.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xff777777),
              ),
            ),

            const SizedBox(height: 20),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xff0000FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Route',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Regular',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Discount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Fare Rows
            ...fares.map(
              (fare) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'SM Terminal → ${fare['route']}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1C1A17),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        '₱${fare['regular'].toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1C1A17),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        '₱${fare['discounted'].toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0000FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0000FF),
                  foregroundColor: Color(0xff0000ff),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discounted fare applies to qualified passengers.',
              style: TextStyle(fontSize: 11, color: Color(0xff888888)),
            ),
          ],
        ),
      ),
    );
  }
}
