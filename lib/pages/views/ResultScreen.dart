import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(
      {super.key,
      required this.barcode,
      required this.baslik,
      required this.aciklama,
      required this.konum,
      required this.tahminiDolumSuresi,
      required this.kumbaraBosaltmaTarihleri});
  final String barcode;
  final String baslik;
  final String aciklama;
  final String konum;
  final int tahminiDolumSuresi;
  final List<Timestamp> kumbaraBosaltmaTarihleri;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int daysLeft = 0;

  @override
  void initState() {
    super.initState();
    calculateDaysLeft();
  }

  void calculateDaysLeft() {
    final now = DateTime.now();
    final lastEmptyDate = widget.kumbaraBosaltmaTarihleri.isNotEmpty
        ? widget.kumbaraBosaltmaTarihleri.last.toDate()
        : now;
    final difference = now.difference(lastEmptyDate).inDays;
    setState(() {
      daysLeft = widget.tahminiDolumSuresi - difference;
      if (daysLeft < 0) daysLeft = 0;
    });
  }

  Future<void> topla() async {
    // Boşaltım işlemi burada yapılacak
    final now = DateTime.now();
    FirebaseFirestore.instance
        .collection('QrCodes')
        .doc(widget.barcode)
        .update({
      'kumbaraBosaltmaTarihleri': FieldValue.arrayUnion([now]),
      'tahminiDolumSuresi': widget.tahminiDolumSuresi,
    });

    setState(() {
      // Ekranı güncelle
      widget.kumbaraBosaltmaTarihleri.add(Timestamp.fromDate(now));
      calculateDaysLeft(); // Tahmini dolum süresi güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Barkod No: ',
                            style: TextStyle(fontSize: 30)),
                        Text(widget.barcode,
                            style: const TextStyle(fontSize: 30)),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Başlık: ', style: TextStyle(fontSize: 30)),
                        Text(widget.baslik,
                            style: const TextStyle(fontSize: 30)),
                      ],
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          const Text('Açıklama: ',
                              style: TextStyle(fontSize: 30)),
                          Text(
                            textAlign: TextAlign.center,
                            widget.aciklama,
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          Text('Tahmini Doluma Kalan Süre: $daysLeft gün',
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 20),
                          const Text('Son Boşaltım Tarihleri:',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          ...widget.kumbaraBosaltmaTarihleri.map((timestamp) {
                            final date = timestamp.toDate();
                            final formattedDate =
                                '${date.day}/${date.month}/${date.year}';
                            return Text(formattedDate,
                                style: const TextStyle(fontSize: 18));
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text('Konum: ', style: TextStyle(fontSize: 30)),
                          Text(widget.konum,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))))),
                      onPressed: topla,
                      child: const Text('Topla')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
