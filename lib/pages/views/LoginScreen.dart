import 'package:app_set_id/app_set_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/component/CustomSnackBar.dart';
import 'package:testt/pages/views/HomeScreen.dart';
import 'package:testt/pages/views/Sign%C4%B0nScreen.dart';

import '../../model/users_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController tellnoController = TextEditingController();
TextEditingController pasController = TextEditingController();
String _girisYap = 'Giriş Yap';

class _LoginScreenState extends State<LoginScreen> {
  String _cihazid = '';
  late String telno, sifre;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _getDeviceId(_cihazid);
    print(_cihazid);
    super.initState();
  }

  Future<String?> _getDeviceId(String cihazid) async {
    cihazid = (await AppSetId().getIdentifier())!;
    print('cihaz id $cihazid');
    _cihazid = cihazid;
    return _cihazid;
  }

  Future<void> saveUserData(Users user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('telNo', telno);
    await prefs.setString('sifre', sifre);
  }

  Future<void> loginUser(String telNo, String sifre, String cihazid) async {
    try {
      var userQuery = await FirebaseFirestore.instance
          .collection('AppUsers')
          .where('telNo', isEqualTo: telNo)
          .where('sifre', isEqualTo: sifre)
          .where('cihazid', isEqualTo: cihazid)
          .get();

      if (userQuery.docs.isNotEmpty) {
        print('Kullanıcı başarı ile giriş yaptı');
        //KULLANICI VERİLERİNİ KAYDEDER.
        await saveUserData(Users(
            adSoyad: '',
            telNo: telNo,
            il: '',
            ilce: '',
            sifre: sifre,
            cihazid: cihazid));

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                telNo: telNo,
              ),
            ));
      } else {
        showCustomSnackBar(context, 'Telefon no Veya Şifre Hatalı!');
        print('Telefon No Veya Şifre Hatalı');
      }
    } catch (e) {
      print('Giriş Başarısız $e');
    }
    //BURAYA CİHAZ İD UYARMASINI EKLE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('KUMBARA TAKİP',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextFormField(
                        onSaved: (newValue) => telno = newValue!,
                        validator: (value) => value == null || value.length < 10
                            ? '10 Haneli Bir Telefon Numarası Girin! '
                            : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall,
                        controller: tellnoController,
                        decoration: const InputDecoration(
                            hintText: 'Telefon Numarası',
                            hintStyle: TextStyle(fontSize: 30),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    //ŞİFRE GİRİŞİ
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          onSaved: (newValue) => sifre = newValue!,
                          validator: (value) =>
                              value == null || value.length < 4
                                  ? 'Şifrenizi Girin!'
                                  : null,
                          style: Theme.of(context).textTheme.displaySmall,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 4,
                          controller: pasController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Şifre',
                              hintStyle: TextStyle(fontSize: 30),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState?.validate() ?? false) {
                          _formkey.currentState?.save();
                          print('$telno ve $sifre');
                          await loginUser(telno, sifre, _cihazid);
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
                      child: Text(_girisYap),
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
                              child: Text('Üye Değil Misin ?'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SigninScreen(
                                              cihazid: _cihazid,
                                            )),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text('Hemen Üye Ol!')),
                            const Expanded(child: Divider())
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
