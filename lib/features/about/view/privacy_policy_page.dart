import 'package:beepbeep_prototype/shared/widgets/about_page_scaffold.dart';
import 'package:beepbeep_prototype/shared/widgets/about_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutPageScaffold(
      title: 'Privacy Policy',
      content: _PrivacyPolicyContent(),
    );
  }
}

class _PrivacyPolicyContent extends StatelessWidget {
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
              'We only collect the information necessary to provide and improve the BeepBeep jeepney tracking platform. Your personal data is never sold to third parties.',
        ),
        SizedBox(height: 20.h),
        const AboutSection(title: 'Data we collect', body: ''),
        SizedBox(height: 8.h),
        const AboutDataRow(
          icon: Icons.location_on_outlined,
          label: 'Location',
          tag: 'While app is active',
        ),
        const AboutDataRow(
          icon: Icons.person_outline,
          label: 'Profile info',
          tag: 'Name, phone, email, adress, plate number',
        ),
        const AboutDataRow(
          icon: Icons.phone_android_outlined,
          label: 'Device info',
          tag: 'OS, app version',
        ),
        SizedBox(height: 18.h),
        const AboutDivider(),
        const AboutSection(
          title: 'How We Use Your Information',
          body:
              'We use your information to provide and improve the BeepBeep platform, including displaying real-time jeepney locations, managing user accounts, enhancing route information, improving system performance, and ensuring the security and reliability of our services. We do not sell your personal data to third parties.',
        ),
        const AboutSection(
          title: 'Data Sharing',
          body:
              'We share data only with trusted service providers that are necessary to operate the BeepBeep platform, such as mapping, cloud hosting, authentication, and database services. These providers are required to protect your information and use it only for the purpose of delivering and improving our services.',
        ),
        const AboutDivider(),
        const AboutSection(
          title: 'Contact us',
          body: 'For privacy-related concerns, reach us at beepbeep@gmail.com',
        ),
      ],
    );
  }
}
