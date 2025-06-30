// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjeModel _$ProjeModelFromJson(Map<String, dynamic> json) => ProjeModel(
      id: (json['id'] as num).toInt(),
      adi: json['adi'] as String,
      kategoriId: (json['kategoriId'] as num).toInt(),
      altKategoriId: (json['altKategoriId'] as num?)?.toInt(),
      faliyetTurId: (json['faliyetTurId'] as num?)?.toInt(),
      departmanId: (json['departmanId'] as num).toInt(),
      sozlesmeTarihi: json['sozlesmeTarihi'] as String,
      baslangicTarihi: json['baslangicTarihi'] as String,
      bitisTarihi: json['bitisTarihi'] as String,
      teslimTarihi: json['teslimTarihi'] as String,
      tahminiBitisTarihi: json['tahminiBitisTarihi'] as String,
      sure: (json['sure'] as num).toInt(),
      tutar: (json['tutar'] as num).toDouble(),
      paraBirimId: (json['paraBirimId'] as num).toInt(),
      ihale: json['ihale'] as bool,
      durumId: (json['durumId'] as num).toInt(),
      aciklama: json['aciklama'] as String,
      kisiId: (json['kisiId'] as num).toInt(),
      geom: json['geom'] as Map<String, dynamic>?,
      ilceId: (json['ilceId'] as num?)?.toInt(),
      mahalleId: (json['mahalleId'] as num).toInt(),
      islemTarihi: json['islemTarihi'] as String,
      kayitEden: json['kayitEden'] as String,
    );

Map<String, dynamic> _$ProjeModelToJson(ProjeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adi': instance.adi,
      'kategoriId': instance.kategoriId,
      'altKategoriId': instance.altKategoriId,
      'faliyetTurId': instance.faliyetTurId,
      'departmanId': instance.departmanId,
      'sozlesmeTarihi': instance.sozlesmeTarihi,
      'baslangicTarihi': instance.baslangicTarihi,
      'bitisTarihi': instance.bitisTarihi,
      'teslimTarihi': instance.teslimTarihi,
      'tahminiBitisTarihi': instance.tahminiBitisTarihi,
      'sure': instance.sure,
      'tutar': instance.tutar,
      'paraBirimId': instance.paraBirimId,
      'ihale': instance.ihale,
      'durumId': instance.durumId,
      'aciklama': instance.aciklama,
      'kisiId': instance.kisiId,
      if (instance.geom case final value?) 'geom': value,
      'ilceId': instance.ilceId,
      'mahalleId': instance.mahalleId,
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
    };
