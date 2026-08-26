import 'package:beepbeep_prototype/shared/components/drawer/widgets/drawer_header.dart';
import 'package:beepbeep_prototype/shared/components/drawer/widgets/drawer_title.dart';
import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  final String currentUser;
  final String role;
  final String? photoURL;
  final bool isGuest;

  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback onAboutTap;
  final VoidCallback onLogOutTap;
  final VoidCallback? onUpgradeTap;

  const DrawerComponent({
    super.key,
    required this.currentUser,
    required this.role,
    required this.photoURL,
    this.onProfileTap,
    this.onSettingsTap,
    required this.onAboutTap,
    required this.onLogOutTap,
    required this.isGuest,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffF8F7F4),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeaderWidget(
              photoURL: photoURL,
              role: role,
              currentUser: currentUser,
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xffE0DED9)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  if (isGuest)
                    DrawerTitleWidget(
                      icon: Icons.account_circle_outlined,
                      label: 'Sign in with Google',
                      onTap: () {
                        Navigator.pop(context);
                        onUpgradeTap?.call();
                      },
                    ),

                  if (!isGuest)
                    DrawerTitleWidget(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      onTap: () {
                        Navigator.pop(context);
                        onProfileTap?.call();
                        // Navigate to Profile
                      },
                    ),

                  DrawerTitleWidget(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      onSettingsTap?.call();
                      // Navigate to Settings
                    },
                  ),
                  DrawerTitleWidget(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      onAboutTap();
                    },
                  ),
                  DrawerTitleWidget(
                    icon: Icons.logout,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: onLogOutTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
