import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testt/pages/views/LoginScreen.dart';

import '../../component/CustomPinPut.dart';
import '../../model/users_model.dart';

class GetPasswordScreen extends StatefulWidget {
  const GetPasswordScreen(
      {super.key,
      required this.adSoyad,
      required this.telNo,
      required this.il,
      required this.ilce,
      required this.cihazid});

  final String adSoyad;
  final String telNo;
  final String il;
  final String ilce;
  final String cihazid;

  @override
  State<GetPasswordScreen> createState() => _GetPasswordScreenState();
}

class _GetPasswordScreenState extends State<GetPasswordScreen> {
  //CONTROLLER TANIMI
  late final TextEditingController c0;
  late final TextEditingController c1;
  late final TextEditingController c2;
  late final TextEditingController c3;

  @override
  void initState() {
    c0 = TextEditingController();
    c1 = TextEditingController();
    c2 = TextEditingController();
    c3 = TextEditingController();

    super.initState();
  }

  Future<void> registerUser(Users user) async {
    try {
      await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.telNo)
          .set(user.toJson());
      print('Kullanıcı Başarı ile Kaydedildi');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Kullanıcı Kaydedilirken bir Sorun Oluştu $e');
    }
  }

  Future<void> kayit(Users user) async {
    try {
      // Telefon numarasını kontrol et
      var telQuery = await FirebaseFirestore.instance
          .collection('AppUsers')
          .where('telNo', isEqualTo: user.telNo)
          .get();
      if (telQuery.docs.isNotEmpty) {
        print('Bu telefon numarası zaten kayıtlı');
        return;
      }

      var cihazQuery = await FirebaseFirestore.instance
          .collection('AppUsers')
          .where('cihazid', isEqualTo: user.cihazid)
          .get();
      if (cihazQuery.docs.isNotEmpty) {
        print('Bu cihaz kimliği zaten kayıtlı');
        return;
      }

      await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.telNo)
          .set(user.toJson());
      print('Kullanıcı başarı ile kaydedildi.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Kullanıcı kaydedilemedi: $e');
    }
  }

  String passwordBirlestir() {
    final List<int> password1 = [];

    var p1 = int.parse(c0.text);
    var p2 = int.parse(c1.text);
    var p3 = int.parse(c2.text);
    var p4 = int.parse(c3.text);

    password1.add(p1);
    password1.add(p2);
    password1.add(p3);
    password1.add(p4);

    //passwordu birleştiriyor String olarak
    String password2 = password1.join();
    print(password2);

    return password2;
  }

  void _saveUser() {
    Users users = Users(
        adSoyad: widget.adSoyad,
        telNo: widget.telNo,
        il: widget.il,
        ilce: widget.ilce,
        sifre: passwordBirlestir(),
        cihazid: widget.cihazid);

    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Lütfen Şifrenizi Girin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Expanded(
              flex: 4, child: CustomPinPut(c0: c0, c1: c1, c2: c2, c3: c3)),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: iptalButonu(context),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: tamamButonu(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //TAMAM BUTONU
  ElevatedButton tamamButonu() {
    return ElevatedButton(
        style: const ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))))),
        onPressed: () {
          passwordBirlestir();
          Users users = Users(
              adSoyad: widget.adSoyad,
              telNo: widget.telNo,
              il: widget.il,
              ilce: widget.ilce,
              sifre: passwordBirlestir(),
              cihazid: widget.cihazid);
          print(users);

          kayit(users);
        },
        child: const Text(
          'Tamam',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ));
  }

  //İPTAL BUTONU
  ElevatedButton iptalButonu(BuildContext context) {
    return ElevatedButton(
        statesController: WidgetStatesController(),
        style: const ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))))),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'İptal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ));
  }
}
