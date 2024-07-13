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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Barkod No: ', style: TextStyle(fontSize: 30)),
                      Text(widget.barcode, style: TextStyle(fontSize: 30)),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Başlık: ', style: TextStyle(fontSize: 30)),
                      Text(widget.baslik, style: TextStyle(fontSize: 30)),
                    ],
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Text('Açıklama: ', style: TextStyle(fontSize: 30)),
                        Text(
                          textAlign: TextAlign.center,
                          widget.aciklama,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Konum: ', style: TextStyle(fontSize: 30)),
                        Text(widget.konum, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              child:
                  ElevatedButton(onPressed: () {}, child: const Text('Topla')),
            )
          ],
        ),
      ),
    );
  }
}
