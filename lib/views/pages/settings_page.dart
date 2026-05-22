import 'package:beepbeep_prototype/views/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.person,
              title: 'Account',
              subtitle: 'Manage your account details',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy',
              subtitle: 'Privacy and permissions',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
