// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetResponseModel _$FaliyetResponseModelFromJson(
        Map<String, dynamic> json) =>
    FaliyetResponseModel(
      faliyetGorevKullanici: FaliyetGorevKullaniciModel.fromJson(
          json['faliyetGorevKullanici'] as Map<String, dynamic>),
      faliyetGorev: FaliyetGorevModel.fromJson(
          json['faliyetGorev'] as Map<String, dynamic>),
      adi: json['adi'] as String?,
      soyadi: json['soyadi'] as String?,
      tcKimlikNo: json['tcKimlikNo'] as String?,
      sicilNo: json['sicilNo'] as String?,
      telefon: json['telefon'] as String?,
      faliyetId: (json['faliyetId'] as num).toInt(),
      faliyetAdi: json['faliyetAdi'] as String?,
      faliyetTuru: json['faliyetTuru'] as String?,
      islem: json['islem'] as String?,
      islemId: (json['islemId'] as num).toInt(),
      baslangicTarihi: json['baslangicTarihi'] as String?,
    );

Map<String, dynamic> _$FaliyetResponseModelToJson(
        FaliyetResponseModel instance) =>
    <String, dynamic>{
      'faliyetGorevKullanici': instance.faliyetGorevKullanici.toJson(),
      'faliyetGorev': instance.faliyetGorev.toJson(),
      'adi': instance.adi,
      'soyadi': instance.soyadi,
      'tcKimlikNo': instance.tcKimlikNo,
      'sicilNo': instance.sicilNo,
      'telefon': instance.telefon,
      'faliyetId': instance.faliyetId,
      'faliyetAdi': instance.faliyetAdi,
      'faliyetTuru': instance.faliyetTuru,
      'islem': instance.islem,
      'islemId': instance.islemId,
      'baslangicTarihi': instance.baslangicTarihi,
    };
