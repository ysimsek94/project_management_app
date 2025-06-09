import 'package:json_annotation/json_annotation.dart';

part 'faliyet_gorev_kullanici_model.g.dart';

@JsonSerializable()
class FaliyetGorevKullaniciModel {
  final String? islemTarihi;
  final String? kayitEden;
  final int id;
  final int faliyetId;
  final int kullaniciId;
  final int gorevId;

  FaliyetGorevKullaniciModel({
    required this.islemTarihi,
    required this.kayitEden,
    required this.id,
    required this.faliyetId,
    required this.kullaniciId,
    required this.gorevId,
  });

  factory FaliyetGorevKullaniciModel.fromJson(Map<String, dynamic> json) =>
      _$FaliyetGorevKullaniciModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetGorevKullaniciModelToJson(this);
}
