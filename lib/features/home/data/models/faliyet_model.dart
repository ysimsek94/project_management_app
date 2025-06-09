// lib/data/models/faliyet_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'faliyet_model.g.dart';

@JsonSerializable()
class FaliyetModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'departmanId')
  final int departmanId;

  @JsonKey(name: 'faliyetTurId')
  final int faliyetTurId;

  @JsonKey(name: 'projeId')
  final int? projeId;

  @JsonKey(name: 'fazId')
  final int? fazId;

  @JsonKey(name: 'islemId')
  final int? islemId;

  @JsonKey(name: 'baslangicTarihi')
  final String baslangicTarihi;

  @JsonKey(name: 'bitisTarihi')
  final String? bitisTarihi;

  @JsonKey(name: 'mahalleId')
  final int? mahalleId;

  @JsonKey(name: 'yer', defaultValue: '')
  final String yer;

  @JsonKey(name: 'aciklama', defaultValue: '')
  final String aciklama;

  @JsonKey(name: 'islem', defaultValue: '')
  final String islem;

  @JsonKey(name: 'fizikiYuzde')
  final double? fizikiYuzde;

  @JsonKey(name: 'durumId')
  final int? durumId;

  @JsonKey(name: 'gorevDurumId')
  final int? gorevDurumId;

  /// GeoJSON or WKT, as your API returns
  @JsonKey(name: 'geom')
  final Map<String, dynamic> geom;

  FaliyetModel({
    required this.id,
    required this.departmanId,
    required this.faliyetTurId,
    this.projeId,
    this.fazId,
    this.islemId,
    required this.baslangicTarihi,
    this.bitisTarihi,
    this.mahalleId,
    required this.yer,
    required this.aciklama,
    required this.islem,
    this.fizikiYuzde,
    this.durumId,
    this.gorevDurumId,
    required this.geom,
  });

  factory FaliyetModel.fromJson(Map<String, dynamic> json) =>
      _$FaliyetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetModelToJson(this);
}