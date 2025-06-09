import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/gorev_durum_enum.dart';

part 'faliyet_gorev_model.g.dart';

@JsonSerializable()
class FaliyetGorevModel {
  final String? islemTarihi;
  final String? kayitEden;
  final int id;
  final int faliyetId;
  final int islemId;
  final String? gorev;
  final String baslangicTarihi;
  final double? fizikiYuzde;
  final String? islem;
  final String? tamamlanmaTarihi;
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? geom;

  @JsonKey(name: 'durumId', fromJson: GorevDurumEnumHelper.fromId, toJson: _gorevDurumToJson)
  final GorevDurumEnum durum;

  FaliyetGorevModel({
    required this.islemTarihi,
    required this.kayitEden,
    required this.id,
    required this.faliyetId,
    required this.islemId,
    required this.gorev,
    required this.baslangicTarihi,
    required this.fizikiYuzde,
    required this.islem,
    required this.tamamlanmaTarihi,
    required this.geom,
    required this.durum,
  });

  factory FaliyetGorevModel.fromJson(Map<String, dynamic> json) =>
      _$FaliyetGorevModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetGorevModelToJson(this);
}

int _gorevDurumToJson(GorevDurumEnum durum) => durum.id;