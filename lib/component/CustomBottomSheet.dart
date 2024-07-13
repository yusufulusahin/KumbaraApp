import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Başlık'),
                  controller: _baslikController,
                  validator: (value) =>
                      value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Açıklama'),
                  controller: _aciklamaController,
                  validator: (value) =>
                      value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Konum'),
                  controller: _konumController,
                  validator: (value) =>
                      value!.isEmpty ? 'Boş Bırakılamaz!' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
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
                  child: const SizedBox(
                    child: Text(
                      'Save',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
