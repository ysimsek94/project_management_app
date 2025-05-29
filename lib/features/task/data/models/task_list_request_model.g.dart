// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskListRequestModel _$TaskListRequestModelFromJson(
        Map<String, dynamic> json) =>
    TaskListRequestModel(
      gorevId: (json['gorevId'] as num).toInt(),
      kullaniciId: (json['kullaniciId'] as num).toInt(),
      durumId: (json['durumId'] as num).toInt(),
      baslangicTarihi: json['baslangicTarihi'] as String,
      baslangicTarihi1: json['baslangicTarihi1'] as String,
    );

Map<String, dynamic> _$TaskListRequestModelToJson(
        TaskListRequestModel instance) =>
    <String, dynamic>{
      'gorevId': instance.gorevId,
      'kullaniciId': instance.kullaniciId,
      'durumId': instance.durumId,
      'baslangicTarihi': instance.baslangicTarihi,
      'baslangicTarihi1': instance.baslangicTarihi1,
    };
