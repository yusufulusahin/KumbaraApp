class Ililce {
  String? il;
  int? plaka;
  List<String>? ilceleri;

  Ililce({this.il, this.plaka, this.ilceleri});

  Ililce.fromJson(Map<String, dynamic> json) {
    il = json['il'];
    plaka = json['plaka'];
    ilceleri = json['ilceleri'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['il'] = this.il;
    data['plaka'] = this.plaka;
    data['ilceleri'] = this.ilceleri;
    return data;
  }
}
