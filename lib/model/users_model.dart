class Users {
  late final String adSoyad;
  late final String telNo;
  late final String il;
  late final String ilce;
  late final String sifre;
  late final String cihazid;

  Users(
      {required this.adSoyad,
      required this.telNo,
      required this.il,
      required this.ilce,
      required this.sifre,
      required this.cihazid});

  Map<String, dynamic> toJson() {
    return {
      'tamAd': adSoyad,
      'telNo': telNo,
      'il': il,
      'ilce': ilce,
      'sifre': sifre,
      'cihazid': cihazid
    };
  }

  // JSON formatındaki veriyi nesneye dönüştüren fonksiyon
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      adSoyad: json['tamAd'],
      telNo: json['telNo'],
      il: json['il'],
      ilce: json['ilce'],
      sifre: json['sifre'],
      cihazid: json['cihazid'],
    );
  }
  //PRİNT METODUNDA USER'İ YAZDIRMAK İÇİN KULLANILIR
  @override
  String toString() {
    return 'User{fullName: $adSoyad, phoneNumber: $telNo, city: $il, district: $ilce, password: $sifre, deviceId: $cihazid}';
  }
}
