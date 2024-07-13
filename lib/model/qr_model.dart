class BoxModel {
  String? barcode;
  String? baslik;
  String? aciklama;
  String? konum;

  BoxModel({this.barcode, this.baslik, this.aciklama, this.konum});

  BoxModel.fromJson(Map<String, dynamic> json) {
    barcode = json['barcode'];
    baslik = json['baslik'];
    aciklama = json['aciklama'];
    konum = json['konum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['baslik'] = this.baslik;
    data['aciklama'] = this.aciklama;
    data['konum'] = this.konum;
    return data;
  }
}
