class BoxModel {
  String? barcode;
  String? baslik;
  String? aciklama;
  String? konum;
  int? tahminiDolumSuresi;
  List<DateTime>? kumbaraBosaltmaTarihleri;

  BoxModel(
      {this.barcode,
      this.baslik,
      this.aciklama,
      this.konum,
      this.tahminiDolumSuresi,
      this.kumbaraBosaltmaTarihleri});

  BoxModel.fromJson(Map<String, dynamic> json) {
    barcode = json['barcode'];
    baslik = json['baslik'];
    aciklama = json['aciklama'];
    konum = json['konum'];
    tahminiDolumSuresi = json['tahminiDolumSuresi'];
    if (json['kumbaraBosaltmaTarihleri'] != null) {
      kumbaraBosaltmaTarihleri = (json['kumbaraBosaltmaTarihleri'] as List)
          .map((e) => DateTime.parse(e))
          .toList();
    } else {
      kumbaraBosaltmaTarihleri = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['baslik'] = this.baslik;
    data['aciklama'] = this.aciklama;
    data['konum'] = this.konum;
    data['tahminiDolumSuresi'] = this.tahminiDolumSuresi;
    data['kumbaraBosaltmaTarihleri'] =
        this.kumbaraBosaltmaTarihleri?.map((e) => e.toIso8601String()).toList();
    return data;
  }
}
