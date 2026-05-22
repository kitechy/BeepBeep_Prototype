import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.r, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No history yet',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
