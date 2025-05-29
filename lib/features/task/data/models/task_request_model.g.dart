// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskRequestModel _$TaskRequestModelFromJson(Map<String, dynamic> json) =>
    TaskRequestModel(
      islemTarihi: json['islemTarihi'] as String? ?? '',
      kayitEden: json['kayitEden'] as String? ?? '',
      id: (json['id'] as num).toInt(),
      fazId: (json['fazId'] as num).toInt(),
      gorev: json['gorev'] as String? ?? '',
      baslangicTarihi: json['baslangicTarihi'] as String? ?? '',
      islem: json['islem'] as String? ?? '',
      nakdiYuzde: (json['nakdiYuzde'] as num?)?.toDouble() ?? 0.0,
      fizikiYuzde: (json['fizikiYuzde'] as num?)?.toDouble() ?? 0.0,
      gerceklesmeYuzde: (json['gerceklesmeYuzde'] as num?)?.toDouble() ?? 0.0,
      tamamlanmaTarihi: json['tamamlanmaTarihi'] as String? ?? '',
      durumId: (json['durumId'] as num?)?.toInt() ?? 0,
      geom: json['geom'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TaskRequestModelToJson(TaskRequestModel instance) =>
    <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'fazId': instance.fazId,
      'gorev': instance.gorev,
      'baslangicTarihi': instance.baslangicTarihi,
      'islem': instance.islem,
      'nakdiYuzde': instance.nakdiYuzde,
      'fizikiYuzde': instance.fizikiYuzde,
      'gerceklesmeYuzde': instance.gerceklesmeYuzde,
      'tamamlanmaTarihi': instance.tamamlanmaTarihi,
      'durumId': instance.durumId,
      if (instance.geom case final value?) 'geom': value,
    };
