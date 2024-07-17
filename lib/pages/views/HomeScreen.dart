import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testt/pages/views/QRScreen.dart';

import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.telNo});
  final String telNo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentindex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void _onTapped(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          _onTapped(value);
        },
        children: <Widget>[
          const Qrscreen(),
          ProfileScreen(
            phonenumber: widget.telNo,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            _pageController.animateToPage(value,
                duration: const Duration(seconds: 1), curve: Curves.easeInOut);
            return _onTapped(value);
          },
          currentIndex: _currentindex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'PROFİL')
          ]),
    );
  }
}
