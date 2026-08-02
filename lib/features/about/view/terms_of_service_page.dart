import 'package:beepbeep_prototype/shared/widgets/about_page_scaffold.dart';
import 'package:beepbeep_prototype/shared/widgets/about_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutPageScaffold(
      title: 'Terms of Service',
      content: _TermsContent(),
    );
  }
}

class _TermsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last updated: August 2, 2026',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
        ),
        SizedBox(height: 14.h),
        const AboutNotice(
          text:
              'By using BeepBeep, you agree to these Terms of Service. Please read them carefully before using the platform.',
        ),
        SizedBox(height: 20.h),
        const AboutSection(
          title: '1. Use of Service',
          body:
              'BeepBeep is a commuter-centered jeepney tracking platform designed for rural and developing areas where jeepneys are the primary mode of public transportation and alternative transport options are limited. The platform provides real-time location tracking and route information to help commuters plan their trips more efficiently. You must be at least 18 years old to create an account and use the service.',
        ),
        const AboutSection(
          title: '2. Your Account',
          body:
              'You are responsible for keeping your login credentials secure. Any activity performed through your account, including accessing route information, tracking jeepneys, and using the platform’s features, is your responsibility.',
        ),
        const AboutSection(
          title: '3. Limitation of Liability',
          body:
              'BeepBeep is a jeepney tracking platform that provides real-time location and route information. While we strive to keep the information accurate and up to date, we do not guarantee its completeness, accuracy, or availability at all times. We are not liable for delays, route changes, service interruptions, traffic conditions, GPS inaccuracies, or any inconvenience or loss resulting from the use of the platform.',
        ),
        const AboutSection(
          title: '4. Changes to Terms',
          body:
              'We may update these terms at any time. Continued use of the app after changes means you accept the updated terms.',
        ),
      ],
    );
  }
}
