import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanOperatorQrPage extends StatefulWidget {
  const ScanOperatorQrPage({super.key});

  @override
  State<ScanOperatorQrPage> createState() => _ScanOperatorQrPageState();
}

class _ScanOperatorQrPageState extends State<ScanOperatorQrPage> {
  bool _scanned = false;

  void _handleBarcode(BarcodeCapture capture) {
    if (_scanned) return;

    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue;

      if (code == null || code.isEmpty) {
        continue;
      }

      _scanned = true;

      Navigator.pop(context, code);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Operator QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),

          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Scan your operator\'s QR code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}