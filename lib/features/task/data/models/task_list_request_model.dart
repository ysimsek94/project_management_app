

import 'package:json_annotation/json_annotation.dart';

part 'task_list_request_model.g.dart';

@JsonSerializable()
class TaskListRequestModel {
  final int gorevId;
  final int kullaniciId;
  final int durumId;
  final String baslangicTarihi;
  final String baslangicTarihi1;

  TaskListRequestModel({
    required this.gorevId,
    required this.kullaniciId,
    required this.durumId,
    required this.baslangicTarihi,
    required this.baslangicTarihi1,
  });

  factory TaskListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskListRequestModelFromJson(json);

  Map<String, dynamic> toJson() => {
    'gorevId': gorevId,
    'kullaniciId': kullaniciId,
    'durumId': durumId,
    'baslangicTarihi': baslangicTarihi,
    'baslangicTarihi1': baslangicTarihi1.isNotEmpty ? baslangicTarihi1 : null,
  };
}