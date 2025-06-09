// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_gorev_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetGorevModel _$FaliyetGorevModelFromJson(Map<String, dynamic> json) =>
    FaliyetGorevModel(
      islemTarihi: json['islemTarihi'] as String?,
      kayitEden: json['kayitEden'] as String?,
      id: (json['id'] as num).toInt(),
      faliyetId: (json['faliyetId'] as num).toInt(),
      islemId: (json['islemId'] as num).toInt(),
      gorev: json['gorev'] as String?,
      baslangicTarihi: json['baslangicTarihi'] as String,
      fizikiYuzde: (json['fizikiYuzde'] as num?)?.toDouble(),
      islem: json['islem'] as String?,
      tamamlanmaTarihi: json['tamamlanmaTarihi'] as String?,
      geom: json['geom'] as Map<String, dynamic>?,
      durum: GorevDurumEnumHelper.fromId((json['durumId'] as num).toInt()),
    );

Map<String, dynamic> _$FaliyetGorevModelToJson(FaliyetGorevModel instance) =>
    <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'faliyetId': instance.faliyetId,
      'islemId': instance.islemId,
      'gorev': instance.gorev,
      'baslangicTarihi': instance.baslangicTarihi,
      'fizikiYuzde': instance.fizikiYuzde,
      'islem': instance.islem,
      'tamamlanmaTarihi': instance.tamamlanmaTarihi,
      if (instance.geom case final value?) 'geom': value,
      'durumId': _gorevDurumToJson(instance.durum),
    };
