import 'package:beepbeep_prototype/features/about/view/privacy_policy_page.dart';
import 'package:beepbeep_prototype/features/about/view/terms_of_service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.r, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About the App',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(height: 1.h, color: const Color(0xFFEAECF0)),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
  
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/beepbeep_splash_logo.png',
                  width: 130.r,
                  height: 130.r,
                ),
                SizedBox(height: 12.h),
                Text(
                  'BeepBeep',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1C1A17),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),
          Divider(color: const Color(0xFFEAECF0)),
          SizedBox(height: 8.h),


          _LegalTile(
            icon: Icons.shield_outlined,
            label: 'Privacy Policy',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
            ),
          ),
          _LegalTile(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TermsOfServicePage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LegalTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
      leading: Icon(icon, color: const Color(0xFF1570EF), size: 22.r),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.r),
      onTap: onTap,
    );
  }
}
