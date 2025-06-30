import 'package:json_annotation/json_annotation.dart';

part 'proje_request_model.g.dart';

@JsonSerializable()
class ProjeRequestModel {
  final int? id;
  final String adi;
  final int kategoriId;
  final int ilceId;
  final int mahalleId;
  final int altKategoriId;
  final int faliyetTurId;
  final int departmanId;
  final String sozlesmeTarihi;
  final String sozlesmeTarihi1;
  final String baslangicTarihi;
  final String baslangicTarihi1;
  final String bitisTarihi;
  final String bitisTarihi1;
  final String teslimTarihi;
  final String teslimTarihi1;
  final int sure;
  final int sure1;
  final double tutar;
  final double tutar1;
  final double nakdiYuzde;
  final double nakdiYuzde1;
  final double fizikiYuzde;
  final double fizikiYuzde1;
  final int parabirimId;
  final bool ihale;
  final bool tamamlanmaYuzdeGoster;
  final int durumId;
  final int kisiId;
  final String aciklama;

  ProjeRequestModel({
    this.id,
    required this.adi,
    required this.kategoriId,
    required this.ilceId,
    required this.mahalleId,
    required this.altKategoriId,
    required this.faliyetTurId,
    required this.departmanId,
    required this.sozlesmeTarihi,
    required this.sozlesmeTarihi1,
    required this.baslangicTarihi,
    required this.baslangicTarihi1,
    required this.bitisTarihi,
    required this.bitisTarihi1,
    required this.teslimTarihi,
    required this.teslimTarihi1,
    required this.sure,
    required this.sure1,
    required this.tutar,
    required this.tutar1,
    required this.nakdiYuzde,
    required this.nakdiYuzde1,
    required this.fizikiYuzde,
    required this.fizikiYuzde1,
    required this.parabirimId,
    required this.ihale,
    required this.tamamlanmaYuzdeGoster,
    required this.durumId,
    required this.kisiId,
    required this.aciklama,
  });

    /// Creates an empty instance with default values.
    ProjeRequestModel.empty()
      : id = null,
        adi = '',
        kategoriId = 0,
        ilceId = 0,
        mahalleId = 0,
        altKategoriId = 0,
        faliyetTurId = 0,
        departmanId = 0,
        sozlesmeTarihi = '',
        sozlesmeTarihi1 = '',
        baslangicTarihi = '',
        baslangicTarihi1 = '',
        bitisTarihi = '',
        bitisTarihi1 = '',
        teslimTarihi = '',
        teslimTarihi1 = '',
        sure = 0,
        sure1 = 0,
        tutar = 0.0,
        tutar1 = 0.0,
        nakdiYuzde = 0.0,
        nakdiYuzde1 = 0.0,
        fizikiYuzde = 0.0,
        fizikiYuzde1 = 0.0,
        parabirimId = 0,
        ihale = false,
        tamamlanmaYuzdeGoster = false,
        durumId = 0,
        kisiId = 0,
        aciklama = '';

  factory ProjeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProjeRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjeRequestModelToJson(this);
}
