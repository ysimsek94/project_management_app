class DashboardTaskModel {
  final int gorevId;
  final String projeAdi;
  final String fazAdi;
  final String gorev;
  final String islem;
  final int durumu;
  final String baslangicTarihi;
  final String tamamlanmaTarihi;

  DashboardTaskModel({
    required this.gorevId,
    required this.projeAdi,
    required this.fazAdi,
    required this.gorev,
    required this.islem,
    required this.durumu,
    required this.baslangicTarihi,
    required this.tamamlanmaTarihi,
  });

  factory DashboardTaskModel.fromJson(Map<String, dynamic> json) {
    return DashboardTaskModel(
      gorevId: json['gorevId'],
      projeAdi: json['projeAdi'],
      fazAdi: json['fazAdi'],
      gorev: json['gorev'],
      islem: json['islem'],
      durumu: json['durumu'],
      baslangicTarihi: json['baslangicTarihi'],
      tamamlanmaTarihi: json['tamamlanmaTarihi'],
    );
  }
}
