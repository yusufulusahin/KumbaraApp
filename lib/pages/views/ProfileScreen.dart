import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
TextEditingController konumilController = TextEditingController();
TextEditingController konumilceController = TextEditingController();
TextEditingController sifreController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
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
        konumilController.text = user.il;
        konumilceController.text = user.ilce;
        sifreController.text = user.sifre;

        print(user);

        return user;
      } else {
        return null;
      }
      // Return the Users object
    } catch (e) {
      print('Bilgi Alırken Bir Sorun Oluştu');
    }
    return null;
  }

  final formKey = GlobalKey<FormState>();
  String? secileIl;
  String? secilenIlce;
  List<Ililce> ililceList = [];

  List<String> get ilceler {
    if (secileIl != null) {
      return ililceList.firstWhere((city) => city.il == secileIl).ilceleri!;
    } else {
      return [];
    }
  }

  Future<void> loadililceData() async {
    String jsondata = await rootBundle.loadString('json/il-ilce.json');
    List<dynamic> jsonList = json.decode(jsondata);
    setState(() {
      ililceList = jsonList.map((json) => Ililce.fromJson(json)).toList();
    });
  }

  @override
  void initState() {
    loadililceData();
    _getData(widget.phonenumber);

    super.initState();
  }

  Future<void> updateUser(String tel) async {
    try {
      var userRef = FirebaseFirestore.instance.collection('AppUsers').doc(tel);

      await userRef.update({
        'tamAd': adSoyadController.text,
        'telNo': telnoController.text,
        'il': konumilController.text,
        'ilce': konumilceController.text!,
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
    print(widget.phonenumber);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Center(
              child: Text('P R O F İ L',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10.0),
              child: IconButton(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    size: 40,
                  )),
            ),
          ]),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Expanded(
                flex: 5,
                child: Form(
                  key: formKey,
                  child: Column(
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
                      // İL VE İLÇE BÖLÜMÜ
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 114, 114, 114))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) => value == null
                                        ? 'Alanı Boş Bırakmayınız!'
                                        : null,
                                    hint: Text(secileIl ?? 'İl'),
                                    items: ililceList
                                        .map<DropdownMenuItem<String>>(
                                            (Ililce city) {
                                      return DropdownMenuItem(
                                        value: city.il,
                                        child: Text(city.il!),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        secileIl = value;
                                        secilenIlce = null;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) => value == null
                                        ? 'Alanı Boş Bırakmayınız!'
                                        : null,
                                    hint: Text(secilenIlce ?? 'İlçe'),
                                    items: ilceler
                                        .map<DropdownMenuItem<String>>(
                                            (String ilce) {
                                      return DropdownMenuItem(
                                        value: ilce,
                                        child: Text(ilce),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        secilenIlce = value;
                                        print("$secileIl,$secilenIlce");
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))))),
                            onPressed: () {
                              updateUser(widget.phonenumber);
                            },
                            child: const Text('K A Y D E T')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
