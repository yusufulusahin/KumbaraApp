import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/component/Colors.dart';
import 'package:testt/component/CustomSnackBar.dart';
import 'package:testt/pages/views/LoginScreen.dart';

import '../../model/il-ilce-model.dart';
import '../../model/users_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.phonenumber});
  final String phonenumber;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

TextEditingController adSoyadController = TextEditingController();
TextEditingController telnoController = TextEditingController();

TextEditingController sifreController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
  String? cihazid;
  final formKey = GlobalKey<FormState>();

  Future<Users?> _getData(String telNo) async {
    try {
      var userss = await FirebaseFirestore.instance
          .collection('AppUsers')
          .where('telNo', isEqualTo: telNo)
          .get();

      if (userss.docs.isNotEmpty) {
        var dokuman = userss.docs[0];
        Users user = Users(
            adSoyad: dokuman['tamAd'],
            telNo: dokuman['telNo'],
            il: dokuman['il'],
            ilce: dokuman['ilce'],
            sifre: dokuman['sifre'],
            cihazid: dokuman['cihazid']);

        adSoyadController.text = user.adSoyad;
        telnoController.text = user.telNo;

        sifreController.text = user.sifre;

        cihazid = user.cihazid;

        print(user);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Bilgi Alırken Bir Sorun Oluştu');
    }
    return null;
  }

  @override
  void initState() {
    _getData(widget.phonenumber);

    super.initState();
  }

  Future<void> updateUser(String cihazid) async {
    try {
      var userRef =
          FirebaseFirestore.instance.collection('AppUsers').doc(cihazid);

      await userRef.update({
        'tamAd': adSoyadController.text,
        'telNo': telnoController.text,
        'sifre': sifreController.text,
      });
      showCustomSnackBar(
          context, 'Kullanıcı Bilgileri Başarı İle Güncellendi!');

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Kullanıcı Güncellenirken Bir Hata Oluştu');
    }
  }

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: UsedColors().backgrounColors,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text('P R O F İ L',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20),
                      child: TextFormField(
                        autocorrect: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            if (value.isEmpty) {
                              return 'Ad Soyad Boş Geçilemez!';
                            } else {
                              return 'Ad Soyad En Az 6 Karakter Olmalıdır!';
                            }
                          } else {
                            return null;
                          }
                        },
                        controller: adSoyadController,
                        decoration: const InputDecoration(
                            hintText: 'Ad Soyad',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length != 4) {
                            if (value.isEmpty) {
                              return 'Sifre Boş Geçilemez!';
                            } else {
                              return 'Şifre 4 Karakter Olmalıdır!';
                            }
                          } else {
                            return null;
                          }
                        },
                        controller: sifreController,
                        decoration: const InputDecoration(
                            hintText: 'Şifre',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    //TELEFON NO BÖLÜMÜ
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length != 10) {
                            return 'Lütfen 10 Haneli Telefon Numarası Giriniz!';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: telnoController,
                        decoration: const InputDecoration(
                            suffixText: '(5**)(***)(****)',
                            hintText: 'Telefon Numarası',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))))),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updateUser(cihazid!);
                        }
                      },
                      child: Text(
                        'K A Y D E T',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))))),
                      onPressed: () {
                        _logout();
                      },
                      child: Text(
                        'Ç I K I Ş  Y A P ',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
