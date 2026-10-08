import 'package:flutter/material.dart';

import 'profile_colors.dart';

class ProfileBanner extends StatelessWidget {
  final double topInset;

  const ProfileBanner({super.key, required this.topInset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
      child: Container(
        height: topInset + 170,
        width: double.infinity,
        color: ProfileColors.blue,
        child: Stack(
          children: [
            Positioned(
              left: -50,
              top: -60,
              child: ProfileRing(size: 200, opacity: 0.10),
            ),
            Positioned(
              right: -40,
              bottom: -70,
              child: ProfileRing(size: 220, opacity: 0.10),
            ),
            Positioned(
              right: 50,
              top: topInset + 30,
              child: ProfileRing(size: 56, opacity: 0.14),
            ),
            Padding(
              padding: EdgeInsets.only(top: topInset + 6),
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (Navigator.canPop(context))
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRing extends StatelessWidget {
  final double size;
  final double opacity;

  const ProfileRing({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(opacity), width: 22),
      ),
    );
  }
}
