class BoxModel {
  String? code;
  String? baslik;
  String? aciklama;
  String? konum;

  BoxModel({this.code, this.baslik, this.aciklama, this.konum});

  BoxModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    baslik = json['baslik'];
    aciklama = json['aciklama'];
    konum = json['konum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['baslik'] = this.baslik;
    data['aciklama'] = this.aciklama;
    data['konum'] = this.konum;
    return data;
  }
}
