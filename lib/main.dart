import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/pages/views/HomeScreen.dart';
import 'package:testt/pages/views/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter KumbaraApp',
      home: FutureBuilder(
        future: _checkLoginData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen(telNo: _userTelNo!);
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  String? _userTelNo;

  Future<bool> _checkLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    _userTelNo = prefs.getString('telNo');
    return prefs.containsKey('telNo') && prefs.containsKey('sifre');
  }
}
