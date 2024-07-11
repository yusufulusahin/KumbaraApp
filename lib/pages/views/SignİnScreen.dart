// ignore_for_file: file_names

import 'dart:convert';

import 'package:app_set_id/app_set_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testt/pages/views/GetPasswordScreen.dart';
import 'package:testt/pages/views/LoginScreen.dart';

import '../../model/il-ilce-model.dart';
import '../../model/users_model.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

TextEditingController adSoyadController = TextEditingController();
TextEditingController telnoController = TextEditingController();
TextEditingController konumilController = TextEditingController();
TextEditingController konumilceController = TextEditingController();

class _SigninScreenState extends State<SigninScreen> {
  String _cihazid = 'Cihaz Kimliği Alınıyor';
  late final Users users;
  final formKey = GlobalKey<FormState>();
  String? secileIl;
  String? secilenIlce;
  List<Ililce> ililceList = [];

//DATALARI YÜKLEMEMEMİZİ SAĞLAR.
  Future<void> loadililceData() async {
    String jsondata = await rootBundle.loadString('json/il-ilce.json');
    List<dynamic> jsonList = json.decode(jsondata);
    setState(() {
      ililceList = jsonList.map((json) => Ililce.fromJson(json)).toList();
    });
  }

//2.SAYFAYA VERİ İLE GEÇME
  void _navigateToPasswordPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetPasswordScreen(
              adSoyad: adSoyadController.text,
              telNo: telnoController.text,
              il: secileIl!,
              ilce: secilenIlce!,
              cihazid: _cihazid),
        ));
  }

  //BU BİZE SEÇTİĞİMİZ İLDEN İLÇELERİ SEÇMEMİZİ SAĞLAR.
  List<String> get ilceler {
    if (secileIl != null) {
      return ililceList.firstWhere((city) => city.il == secileIl).ilceleri!;
    } else {
      return [];
    }
  }

  //CİHAZ_İD ALMA
  Future<String?> _getDeviceId(String cihazid) async {
    cihazid = (await AppSetId().getIdentifier())!;
    print('cihaz id $cihazid');
    _cihazid = cihazid;
    return _cihazid;
  }

  //İNİT ETMEMİZİ SAĞLAR
  @override
  void initState() {
    loadililceData();

    _getDeviceId(_cihazid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            //HOŞ GELDİNİZ BÖLÜMÜ
            Expanded(
              flex: 2,
              child: Center(
                child: Text('Hoş geldiniz !',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            //AD SOYAD BÖLÜMÜ
            Expanded(
              flex: 3,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20),
                      child: TextFormField(
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
                                color:
                                    const Color.fromARGB(255, 114, 114, 114))),
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
                                  items: ilceler.map<DropdownMenuItem<String>>(
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
                    //PASSWORDALMA EKRANINA GİT BUTONU
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _navigateToPasswordPage();
                        }
                      },
                      style: const ButtonStyle(
                          side: WidgetStatePropertyAll(BorderSide(
                              color: Color.fromARGB(255, 142, 142, 142))),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 226, 225, 225)),
                          minimumSize: WidgetStatePropertyAll(Size(220, 70)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )))),
                      child: const Text('Devam'),
                    ),
                    Expanded(
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(child: Divider()),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text('Zaten üye misin ?'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text('Hemen Giriş Yap!')),
                            const Expanded(child: Divider())
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
