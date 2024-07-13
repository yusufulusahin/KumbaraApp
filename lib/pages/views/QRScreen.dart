import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testt/component/CustomSnackBar.dart';

import '../../component/CustomBottomSheet.dart';
import 'ResultScreen.dart';

class Qrscreen extends StatefulWidget {
  const Qrscreen({super.key});

  @override
  State<Qrscreen> createState() => _QrscreenState();
}

class _QrscreenState extends State<Qrscreen> {
  MobileScannerController scannerController = MobileScannerController();
  late final String barcode;

  Future<void> checkBarcode(String barcode) async {
    var doc = await FirebaseFirestore.instance
        .collection('QrCodes')
        .where('barcode', isEqualTo: barcode)
        .get();

    if (doc.docs.isNotEmpty) {
      var dokuman = doc.docs[0];
      //Barkod No Bulunursa
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              barcode: barcode,
              baslik: dokuman['baslik'],
              aciklama: dokuman['aciklama'],
              konum: dokuman['konum'],
            ),
          ));
    } else {
      //Barkod No Bulunmazsa

      showModalBottomSheet(
        context: context,
        builder: (context) => Custombottomsheet(barcode: barcode),
        isScrollControlled: true,
      );
    }
  }

  void _onDetect(BarcodeCapture barcodeCapture) async {
    final List<Barcode> barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? "Kod Bulunamadı";
      if (code.isNotEmpty) {
        scannerController.stop();
        barcode = code;

        await checkBarcode(barcode);
      }
      showCustomSnackBar(context, 'Tarama Sonucu $code');

      print('$barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'QR Tarayıcı',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
        elevation: 0.0,
      ),
      body: MobileScanner(controller: scannerController, onDetect: _onDetect),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scannerController.toggleTorch();
        },
        child: const Icon(Icons.flash_on),
      ),
    );
  }
}
