import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/profile_banner.dart';
import 'widgets/profile_colors.dart';
import 'widgets/profile_details_widgets.dart';
import 'widgets/profile_invite_code_card.dart';
import 'widgets/profile_reveal.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String? email;
  final String? photoURL;
  final String role;
  final String? invCode;

  const ProfilePage({
    super.key,
    required this.name,
    this.email,
    this.photoURL,
    required this.role,
    this.invCode,
  });

  String get _roleLabel =>
      role.isEmpty ? role : role[0].toUpperCase() + role.substring(1);

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoURL != null && photoURL!.isNotEmpty;
    final hasEmail = email != null && email!.isNotEmpty;
    final topInset = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ProfileColors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ProfileBanner(topInset: topInset),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -60,
                    child: Center(
                      child: ProfileReveal(
                        index: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ProfileColors.card,
                            boxShadow: [
                              BoxShadow(
                                color: ProfileColors.ink.withOpacity(0.14),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: ProfileColors.blue,
                            backgroundImage: hasPhoto
                                ? NetworkImage(photoURL!)
                                : null,
                            child: hasPhoto
                                ? null
                                : Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 42,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 72),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  children: [
                    ProfileReveal(
                      index: 1,
                      child: Column(
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ProfileColors.ink,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: ProfileColors.card,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: ProfileColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: ProfileColors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _roleLabel.toUpperCase(),
                                  style: const TextStyle(
                                    color: ProfileColors.ink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ProfileReveal(
                      index: 2,
                      child: Column(
                        children: [
                          const ProfileSectionLabel('Details'),
                          Container(
                            decoration: BoxDecoration(
                              color: ProfileColors.card,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: ProfileColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: ProfileColors.ink.withOpacity(0.05),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ProfileInfoRow(
                                  icon: Icons.person_outline_rounded,
                                  label: 'Name',
                                  value: name,
                                ),
                                const ProfileRowDivider(),
                                ProfileInfoRow(
                                  icon: Icons.mail_outline_rounded,
                                  label: 'Email',
                                  value: hasEmail ? email! : 'Not provided',
                                  dimmed: !hasEmail,
                                ),
                                const ProfileRowDivider(),
                                ProfileInfoRow(
                                  icon: Icons.verified_user_outlined,
                                  label: 'Role',
                                  value: _roleLabel,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (invCode != null) ...[
                      const SizedBox(height: 24),
                      ProfileReveal(
                        index: 3,
                        child: ProfileInviteCodeCard(code: invCode!),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
