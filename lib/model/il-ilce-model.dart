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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['il'] = il;
    data['plaka'] = plaka;
    data['ilceleri'] = ilceleri;
    return data;
  }
}
