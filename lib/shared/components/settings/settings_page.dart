import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/features/auth/view/login_page.dart';
import 'package:beepbeep_prototype/shared/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _openGoogleAccountSettings(BuildContext context) async {
    final uri = Uri.parse('https://myaccount.google.com/security');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const ErrorDialog(
            message: 'Could not open Google account settings.',
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xffD32F2F)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final authRepo = context.read<AuthRepository>();

    try {
      await authRepo.deleteAccount();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          message:
              'Failed to delete account. You may need to sign in again before retrying.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F7F4),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Color(0xff1C1A17), fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Color(0xff1C1A17)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined, color: Color(0xff1C1A17)),
            title: const Text('Manage Google Account'),
            subtitle: const Text('Change password, security settings'),
            onTap: () => _openGoogleAccountSettings(context),
          ),
          const Divider(height: 1, color: Color(0xffE0DED9)),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xffD32F2F)),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Color(0xffD32F2F)),
            ),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }
}