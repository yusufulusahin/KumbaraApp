import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/pages/views/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.phonenumber});
  final String phonenumber;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.phonenumber);
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
      ]),
      body: const Scaffold(),
    );
  }
}
