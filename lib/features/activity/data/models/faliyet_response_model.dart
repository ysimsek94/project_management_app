import 'package:json_annotation/json_annotation.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_kullanici_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_model.dart';

part 'faliyet_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FaliyetResponseModel {
  final FaliyetGorevKullaniciModel faliyetGorevKullanici;
  final FaliyetGorevModel faliyetGorev;
  final String? adi;
  final String? soyadi;
  final String? tcKimlikNo;
  final String? sicilNo;
  final String? telefon;
  final int faliyetId;
  final String? faliyetAdi;
  final String? faliyetTuru;
  final String? islem;
  final int islemId;
  final String? baslangicTarihi;

  FaliyetResponseModel({
    required this.faliyetGorevKullanici,
    required this.faliyetGorev,
    required this.adi,
    required this.soyadi,
    required this.tcKimlikNo,
    required this.sicilNo,
    required this.telefon,
    required this.faliyetId,
    required this.faliyetAdi,
    required this.faliyetTuru,
    required this.islem,
    required this.islemId,
    required this.baslangicTarihi,
  });

  factory FaliyetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FaliyetResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetResponseModelToJson(this);
}
