import 'package:beepbeep_prototype/models/app.user.role.dart';
import 'package:beepbeep_prototype/models/drawer_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  final AppUserRole role;

  final User? user;

  final VoidCallback? onHomeTap;

  final VoidCallback? onProfileTap;

  final VoidCallback? onPlaceholderTap;

  final VoidCallback? onAboutTap;

  final VoidCallback? onLogOutTap;

  const DrawerComponent({
    super.key,
    required this.role,
    this.user,
    this.onHomeTap,
    this.onProfileTap,
    this.onPlaceholderTap,
    this.onAboutTap,
    this.onLogOutTap,
  });

  List<DrawerItem> _itemsForRole() {
    switch (role) {
      case AppUserRole.commuter:
      return [
        DrawerItem(
          icon: Icons.map_outlined,
          label: 'Live Map',
          onTap: onHomeTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.extension_outlined,
          label: 'Placeholder', 
          onTap: onPlaceholderTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.info_outline_rounded,
          label: 'About',
          onTap: onAboutTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          onTap: onLogOutTap ?? () {},
          isDestructive: true,
        ),
      ];

      case AppUserRole.driver:
      return [
        DrawerItem(
          icon: Icons.map_outlined,
          label: 'Live Map',
          onTap: onHomeTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.person_outline_rounded,
          label: 'My Profile',
          onTap: onProfileTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.info_outline_rounded,
          label: 'About',
          onTap: onAboutTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          onTap: onLogOutTap ?? () {},
          isDestructive: true,
        ),
      ];

      case AppUserRole.operator:
      return [
        DrawerItem(
          icon: Icons.extension_outlined,
          label: 'Placeholder',
          onTap: onHomeTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.person_outline_rounded,
          label: 'My Profile',
          onTap: onProfileTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.info_outline_rounded,
          label: 'About',
          onTap: onAboutTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          onTap: onLogOutTap ?? () {},
          isDestructive: true,
        ),
      ];

      case AppUserRole.guest:
      return [
        DrawerItem(
          icon: Icons.map_outlined,
          label: 'Live Map',
          onTap: onHomeTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.info_outline_rounded,
          label: 'About',
          onTap: onAboutTap ?? () {},
        ),
        DrawerItem(
          icon: Icons.login_rounded,
          label: 'Sign In',
          onTap: onLogOutTap ?? () {},
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsForRole();

    return Drawer(
      backgroundColor: const Color(0xffF8F7F4),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(role: role, user: user),

            const Divider(height: 1, thickness: 1, color: Color(0xffE0DED9)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _DrawerTitle(item: item);
                },
              ),
            ),
          ]
        )
      )
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final AppUserRole role;
  final User? user;

  const _DrawerHeader({required this.role, this.user});

  String get _roleLabel {
    switch (role) {
      case AppUserRole.commuter:
        return 'Commuter';
      case AppUserRole.driver:
        return 'Driver';
      case AppUserRole.operator:
        return 'Operator';
      case AppUserRole.guest:
        return 'Guest';
    }
  }

  String get _displayFirstName {
    final name = user?.displayName;
    if (name != null && name.trim().isNotEmpty) {
      return name.trim().split(' ').first;
    }
    return 'BeepBeep';
  }

  String get _subtitle {
    if (user?.email != null && user!.email!.isNotEmpty) {
      return user!.email!;
    }
    return _roleLabel;
  }

  String get _avatarInitial {
    if (_displayFirstName.isNotEmpty && _displayFirstName != 'BeepBeep') {
      return _displayFirstName[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xff0056FF),
            backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
            child: hasPhoto
                ? null
                : Text(
                    _avatarInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayFirstName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1A17),
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  _subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6B6966),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTitle extends StatelessWidget {
  final DrawerItem item;

  const _DrawerTitle({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isDestructive
      ? const Color(0xffD32F2F)
      : const Color(0xff1C1A17);

    return ListTile(
      leading: Icon(item.icon, color: color, size: 22),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
      onTap: () {
        Navigator.pop(context);
        item.onTap();
      },
    );
  }
}