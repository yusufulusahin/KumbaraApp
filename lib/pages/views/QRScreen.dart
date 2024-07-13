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
  bool isCameraActive = true;
  bool isBottomSheetOpen = false;
  String? barcode;

  Future<void> checkBarcode(String barcode) async {
    var doc = await FirebaseFirestore.instance
        .collection('QrCodes')
        .where('barcode', isEqualTo: barcode)
        .get();

    if (doc.docs.isNotEmpty) {
      var dokuman = doc.docs[0];
      // Barkod No Bulunursa
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              barcode: barcode,
              baslik: dokuman['baslik'],
              aciklama: dokuman['aciklama'],
              konum: dokuman['konum'],
            ),
          )).then((_) {
        // Sayfadan geri dönüldüğünde kamerayı yeniden başlat
        scannerController.start();
        setState(() {
          this.barcode = null; // Barcode değerini sıfırlama
        });
      });
    } else {
      // Barkod No Bulunmazsa
      setState(() {
        isBottomSheetOpen = true;
      });
      showModalBottomSheet(
        context: context,
        builder: (context) => Custombottomsheet(barcode: barcode),
        isScrollControlled: true,
      ).whenComplete(() {
        setState(() {
          isBottomSheetOpen = false;
          this.barcode = null; // Barcode değerini sıfırlama
        });
        // BottomSheet kapandığında kamerayı yeniden başlat
        scannerController.start();
      });
    }
  }

  void _cameraActive() {
    if (isCameraActive) {
      scannerController.stop();
    } else {
      scannerController.start();
      setState(() {
        barcode = null; // Barcode değerini sıfırlama
      });
    }
    setState(() {
      isCameraActive = !isCameraActive;
    });
  }

  void _onDetect(BarcodeCapture barcodeCapture) async {
    final List<Barcode> barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty && !isBottomSheetOpen) {
      final String code = barcodes.first.rawValue ?? "Kod Bulunamadı";
      if (code.isNotEmpty && barcode != code) {
        scannerController.stop();
        setState(() {
          barcode = code;
        });
        await checkBarcode(code);
      }
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'cameraButton', // Benzersiz heroTag ekledik
              onPressed: _cameraActive,
              child: Icon(isCameraActive ? Icons.camera : Icons.camera_alt),
            ),
            FloatingActionButton(
              heroTag: 'torchButton', // Benzersiz heroTag ekledik
              onPressed: () {
                scannerController.toggleTorch();
              },
              child: const Icon(Icons.flash_on),
            ),
          ],
        ),
      ),
    );
  }
}
