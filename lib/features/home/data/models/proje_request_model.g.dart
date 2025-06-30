// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjeRequestModel _$ProjeRequestModelFromJson(Map<String, dynamic> json) =>
    ProjeRequestModel(
      id: (json['id'] as num?)?.toInt(),
      adi: json['adi'] as String,
      kategoriId: (json['kategoriId'] as num).toInt(),
      ilceId: (json['ilceId'] as num).toInt(),
      mahalleId: (json['mahalleId'] as num).toInt(),
      altKategoriId: (json['altKategoriId'] as num).toInt(),
      faliyetTurId: (json['faliyetTurId'] as num).toInt(),
      departmanId: (json['departmanId'] as num).toInt(),
      sozlesmeTarihi: json['sozlesmeTarihi'] as String,
      sozlesmeTarihi1: json['sozlesmeTarihi1'] as String,
      baslangicTarihi: json['baslangicTarihi'] as String,
      baslangicTarihi1: json['baslangicTarihi1'] as String,
      bitisTarihi: json['bitisTarihi'] as String,
      bitisTarihi1: json['bitisTarihi1'] as String,
      teslimTarihi: json['teslimTarihi'] as String,
      teslimTarihi1: json['teslimTarihi1'] as String,
      sure: (json['sure'] as num).toInt(),
      sure1: (json['sure1'] as num).toInt(),
      tutar: (json['tutar'] as num).toDouble(),
      tutar1: (json['tutar1'] as num).toDouble(),
      nakdiYuzde: (json['nakdiYuzde'] as num).toDouble(),
      nakdiYuzde1: (json['nakdiYuzde1'] as num).toDouble(),
      fizikiYuzde: (json['fizikiYuzde'] as num).toDouble(),
      fizikiYuzde1: (json['fizikiYuzde1'] as num).toDouble(),
      parabirimId: (json['parabirimId'] as num).toInt(),
      ihale: json['ihale'] as bool,
      tamamlanmaYuzdeGoster: json['tamamlanmaYuzdeGoster'] as bool,
      durumId: (json['durumId'] as num).toInt(),
      kisiId: (json['kisiId'] as num).toInt(),
      aciklama: json['aciklama'] as String,
    );

Map<String, dynamic> _$ProjeRequestModelToJson(ProjeRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adi': instance.adi,
      'kategoriId': instance.kategoriId,
      'ilceId': instance.ilceId,
      'mahalleId': instance.mahalleId,
      'altKategoriId': instance.altKategoriId,
      'faliyetTurId': instance.faliyetTurId,
      'departmanId': instance.departmanId,
      'sozlesmeTarihi': instance.sozlesmeTarihi,
      'sozlesmeTarihi1': instance.sozlesmeTarihi1,
      'baslangicTarihi': instance.baslangicTarihi,
      'baslangicTarihi1': instance.baslangicTarihi1,
      'bitisTarihi': instance.bitisTarihi,
      'bitisTarihi1': instance.bitisTarihi1,
      'teslimTarihi': instance.teslimTarihi,
      'teslimTarihi1': instance.teslimTarihi1,
      'sure': instance.sure,
      'sure1': instance.sure1,
      'tutar': instance.tutar,
      'tutar1': instance.tutar1,
      'nakdiYuzde': instance.nakdiYuzde,
      'nakdiYuzde1': instance.nakdiYuzde1,
      'fizikiYuzde': instance.fizikiYuzde,
      'fizikiYuzde1': instance.fizikiYuzde1,
      'parabirimId': instance.parabirimId,
      'ihale': instance.ihale,
      'tamamlanmaYuzdeGoster': instance.tamamlanmaYuzdeGoster,
      'durumId': instance.durumId,
      'kisiId': instance.kisiId,
      'aciklama': instance.aciklama,
    };
