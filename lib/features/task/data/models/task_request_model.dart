import 'package:json_annotation/json_annotation.dart';
import '../../../../core/constants/gorev_durum_enum.dart';

part 'task_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskRequestModel {
  @JsonKey(defaultValue: '')
  final String islemTarihi;
  @JsonKey(defaultValue: '')
  final String kayitEden;
  final int id;
  final int fazId;
  @JsonKey(defaultValue: '')
  final String gorev;
  @JsonKey(defaultValue: '')
  final String baslangicTarihi;
  @JsonKey(defaultValue: '')
  final String islem;
  @JsonKey(defaultValue: 0.0)
  final double nakdiYuzde;
  @JsonKey(defaultValue: 0.0)
  final double fizikiYuzde;
  @JsonKey(defaultValue: 0.0)
  final double gerceklesmeYuzde;
  @JsonKey(defaultValue: '')
  final String tamamlanmaTarihi;
  @JsonKey(name: 'durumId', fromJson: GorevDurumEnumHelper.fromId, toJson: _gorevDurumToJson)
  final GorevDurumEnum durum;
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? geom;

  TaskRequestModel({
    required this.islemTarihi,
    required this.kayitEden,
    required this.id,
    required this.fazId,
    required this.gorev,
    required this.baslangicTarihi,
    required this.islem,
    required this.nakdiYuzde,
    required this.fizikiYuzde,
    required this.gerceklesmeYuzde,
    required this.tamamlanmaTarihi,
    required this.durum,
    this.geom,
  });

  factory TaskRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskRequestModelToJson(this);
}

int _gorevDurumToJson(GorevDurumEnum durum) => durum.id;