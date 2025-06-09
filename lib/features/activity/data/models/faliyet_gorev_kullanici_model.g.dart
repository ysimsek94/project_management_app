// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_gorev_kullanici_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetGorevKullaniciModel _$FaliyetGorevKullaniciModelFromJson(
        Map<String, dynamic> json) =>
    FaliyetGorevKullaniciModel(
      islemTarihi: json['islemTarihi'] as String?,
      kayitEden: json['kayitEden'] as String?,
      id: (json['id'] as num).toInt(),
      faliyetId: (json['faliyetId'] as num).toInt(),
      kullaniciId: (json['kullaniciId'] as num).toInt(),
      gorevId: (json['gorevId'] as num).toInt(),
    );

Map<String, dynamic> _$FaliyetGorevKullaniciModelToJson(
        FaliyetGorevKullaniciModel instance) =>
    <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'faliyetId': instance.faliyetId,
      'kullaniciId': instance.kullaniciId,
      'gorevId': instance.gorevId,
    };
