import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testt/component/CustomSnackBar.dart';

import 'QRResultScreen.dart';

class Qrscreen extends StatefulWidget {
  const Qrscreen({super.key});

  @override
  State<Qrscreen> createState() => _QrscreenState();
}

class _QrscreenState extends State<Qrscreen> {
  MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    //this._screenWasOpened();
    super.initState();
  }

  void _onDetect(BarcodeCapture barcodeCapture) {
    final List<Barcode> barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? "Kod Bulunamadı";
      showCustomSnackBar(context, 'Tarama Sonucu $code');
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
        child: Icon(Icons.flash_on),
      ),
    );
  }
}
