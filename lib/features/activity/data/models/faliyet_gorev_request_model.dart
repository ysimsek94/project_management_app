import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/gorev_durum_enum.dart';

part 'faliyet_gorev_request_model.g.dart';

@JsonSerializable()
class FaliyetGorevRequestModel {
  final int gorevId;
  final int kullaniciId;
  @JsonKey(fromJson: GorevDurumEnumHelper.fromId, toJson: _gorevDurumToJson)
  final GorevDurumEnum durum;
  final String baslangicTarihi;
  final String? baslangicTarihi1;

  FaliyetGorevRequestModel({
    required this.gorevId,
    required this.kullaniciId,
    required this.durum,
    required this.baslangicTarihi,
    required this.baslangicTarihi1,
  });

  factory FaliyetGorevRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FaliyetGorevRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetGorevRequestModelToJson(this);
}

int _gorevDurumToJson(GorevDurumEnum durum) => durum.id;