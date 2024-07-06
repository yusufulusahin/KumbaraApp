import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testt/pages/views/HomeScreen.dart';
import 'package:testt/pages/views/Sign%C4%B0nScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController tellnoController = TextEditingController();
TextEditingController pasController = TextEditingController();
String errrorMesage = 'Şifre 10 Haneli Olmalıdır.';

class _LoginScreenState extends State<LoginScreen> {
  void controlTel(String phoneNumberControl) {
    setState(() {
      if (phoneNumberControl.length != 10) {
        errrorMesage = '10 Haneli Bir Telefon Numarası Girin!';
      } else {
        errrorMesage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      body: Column(
        children: [
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
          Expanded(
            flex: 3,
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: TextField(
                      onChanged: controlTel,
                      keyboardType: TextInputType.phone,
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
                      child: TextField(
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                        maxLength: 4,
                        controller: pasController,
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
                    onPressed: () {
                      if (tellnoController.text.length == 10) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homescreen()), (route) {
                          return false;
                        });
                      } else {
                        controlTel(tellnoController.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errrorMesage),
                          duration: const Duration(seconds: 2),
                        ));
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
                    child: const Text('Giriş Yap'),
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
                                      builder: (context) =>
                                          const SigninScreen()),
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
            ),
          )
        ],
      ),
    );
  }
}
