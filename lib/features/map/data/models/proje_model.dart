
import 'package:json_annotation/json_annotation.dart';

part 'proje_model.g.dart';

@JsonSerializable()
class ProjeModel {
  final int id;
  final String adi;
  final int kategoriId;
  final int? altKategoriId;
  final int? faliyetTurId;
  final int departmanId;
  final String sozlesmeTarihi;
  final String baslangicTarihi;
  final String bitisTarihi;
  final String teslimTarihi;
  final String tahminiBitisTarihi;
  final int sure;
  final double tutar;
  final int paraBirimId;
  final bool ihale;
  final int durumId;
  final String aciklama;
  final int kisiId;
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? geom;
  final int? ilceId;
  final int mahalleId;
  final String islemTarihi;
  final String kayitEden;

  ProjeModel({
    required this.id,
    required this.adi,
    required this.kategoriId,
    this.altKategoriId,
    this.faliyetTurId,
    required this.departmanId,
    required this.sozlesmeTarihi,
    required this.baslangicTarihi,
    required this.bitisTarihi,
    required this.teslimTarihi,
    required this.tahminiBitisTarihi,
    required this.sure,
    required this.tutar,
    required this.paraBirimId,
    required this.ihale,
    required this.durumId,
    required this.aciklama,
    required this.kisiId,
    this.geom,
    this.ilceId,
    required this.mahalleId,
    required this.islemTarihi,
    required this.kayitEden,
  });

  factory ProjeModel.fromJson(Map<String, dynamic> json) =>
      _$ProjeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjeModelToJson(this);
}