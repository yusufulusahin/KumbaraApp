import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(
      {super.key,
      required this.barcode,
      required this.baslik,
      required this.aciklama,
      required this.konum});
  final String barcode;
  final String baslik;
  final String aciklama;
  final String konum;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Text(widget.barcode)),
          Expanded(child: Text(widget.baslik)),
          Expanded(child: Text(widget.aciklama)),
          Expanded(child: Text(widget.konum)),
          Expanded(
              child: SizedBox(
            child: ElevatedButton(onPressed: () {}, child: const Text('Topla')),
          ))
        ],
      ),
    );
  }
}
