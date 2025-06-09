// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_gorev_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetGorevRequestModel _$FaliyetGorevRequestModelFromJson(
        Map<String, dynamic> json) =>
    FaliyetGorevRequestModel(
      gorevId: (json['gorevId'] as num).toInt(),
      kullaniciId: (json['kullaniciId'] as num).toInt(),
      durum: GorevDurumEnumHelper.fromId((json['durum'] as num).toInt()),
      baslangicTarihi: json['baslangicTarihi'] as String,
      baslangicTarihi1: json['baslangicTarihi1'] as String?,
    );

Map<String, dynamic> _$FaliyetGorevRequestModelToJson(
        FaliyetGorevRequestModel instance) =>
    <String, dynamic>{
      'gorevId': instance.gorevId,
      'kullaniciId': instance.kullaniciId,
      'durum': _gorevDurumToJson(instance.durum),
      'baslangicTarihi': instance.baslangicTarihi,
      'baslangicTarihi1': instance.baslangicTarihi1,
    };
