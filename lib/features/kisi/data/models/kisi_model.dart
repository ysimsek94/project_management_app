import 'package:json_annotation/json_annotation.dart';

part 'kisi_model.g.dart';

@JsonSerializable()
class KisiModel {
  final String? islemTarihi;
  final String? kayitEden;
  final int id;
  final String? tcVergiNo;
  final String? adi;
  final String? soyadi;
  final String? babaAdi;
  final String? dogumTarihi;
  final String? cinsiyet;
  final String? dogumYeri;
  final int? ilceId;
  final String? adres;
  final String? ybsSicilNo;
  final String? email;
  final String? telefon;
  final String? telefon2;
  final String? vergiDairesi;
  final int? ehliyetTurId;
  final String? ehliyetNo;
  final int? kanGrupId;
  final int? egitimDurumId;
  final String? aciklama;
  final String? iban;
  final String? banka;
  final bool? sil;
  final bool? nvi;

  KisiModel({
    this.islemTarihi,
    this.kayitEden,
    required this.id,
    this.tcVergiNo,
    this.adi,
    this.soyadi,
    this.babaAdi,
    this.dogumTarihi,
    this.cinsiyet,
    this.dogumYeri,
    this.ilceId,
    this.adres,
    this.ybsSicilNo,
    this.email,
    this.telefon,
    this.telefon2,
    this.vergiDairesi,
    this.ehliyetTurId,
    this.ehliyetNo,
    this.kanGrupId,
    this.egitimDurumId,
    this.aciklama,
    this.iban,
    this.banka,
     this.sil,
     this.nvi,
  });

  factory KisiModel.fromJson(Map<String, dynamic> json) =>
      _$KisiModelFromJson(json);

  Map<String, dynamic> toJson() => _$KisiModelToJson(this);
}