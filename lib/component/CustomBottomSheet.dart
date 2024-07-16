import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testt/component/CustomSnackBar.dart';
import 'package:testt/model/qr_model.dart';

class Custombottomsheet extends StatefulWidget {
  const Custombottomsheet({Key? key, required this.barcode}) : super(key: key);
  final String barcode;

  @override
  State<Custombottomsheet> createState() => _CustombottomsheetState();
}

class _CustombottomsheetState extends State<Custombottomsheet> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _baslikController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _konumController = TextEditingController();

  Future<void> saveBarcode(BoxModel model) async {
    try {
      if (_formkey.currentState!.validate()) {
        await FirebaseFirestore.instance
            .collection('QrCodes')
            .doc(model.barcode)
            .set(model.toJson());
        showCustomSnackBar(context, 'Barkod Başarı İle Kaydedildi!');
        Navigator.pop(context);
      }
    } catch (e) {
      showCustomSnackBar(context, 'Barcode Kaydedilirken Bir Sorun Oluştu!');
      print('Barcode Kaydedilirken Bir Sorun Oluştu! $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Başlık'),
                    controller: _baslikController,
                    validator: (value) =>
                        value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Açıklama'),
                    controller: _aciklamaController,
                    validator: (value) =>
                        value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Konum'),
                    controller: _konumController,
                    validator: (value) =>
                        value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'İptal',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))))),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            BoxModel model = BoxModel(
                              barcode: widget.barcode,
                              baslik: _baslikController.text,
                              aciklama: _aciklamaController.text,
                              konum: _konumController.text,
                            );
                            saveBarcode(model);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Kaydet',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
