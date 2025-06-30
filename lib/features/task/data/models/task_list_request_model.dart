import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/gorev_durum_enum.dart';

part 'task_list_request_model.g.dart';

@JsonSerializable()
class TaskListRequestModel {
  final int gorevId;
  final int? kullaniciId;
  @JsonKey(name: 'durumId', fromJson: GorevDurumEnumHelper.fromId, toJson: _gorevDurumToJson)
  final GorevDurumEnum durum;
  final String? baslangicTarihi;
  final String? baslangicTarihi1;

  TaskListRequestModel({
    required this.gorevId,
    this.kullaniciId,
    required this.durum,
    required this.baslangicTarihi,
    this.baslangicTarihi1,
  });

  factory TaskListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskListRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListRequestModelToJson(this);
}
int _gorevDurumToJson(GorevDurumEnum durum) => durum.id;