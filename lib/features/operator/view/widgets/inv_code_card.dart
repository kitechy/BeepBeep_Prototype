import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InvCodeCard extends StatelessWidget {
  final String invCode;
  const InvCodeCard({super.key, required this.invCode});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.vpn_key_rounded, color: Color(0xff0000FF)),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Operator Invitation Code',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: invCode),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invitation code copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
