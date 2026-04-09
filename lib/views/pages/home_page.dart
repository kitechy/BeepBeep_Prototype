import 'package:beepbeep_prototype/controller/google_auth.dart';
import 'package:beepbeep_prototype/views/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleSignOut() async {
    try {
      await signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-Out failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: _handleSignOut,
            icon: Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Home Page!')),
    );
  }
}
