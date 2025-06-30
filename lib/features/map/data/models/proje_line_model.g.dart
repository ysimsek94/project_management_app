// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjeLineModel _$ProjeLineModelFromJson(Map<String, dynamic> json) =>
    ProjeLineModel(
      proje: ProjeModel.fromJson(json['proje'] as Map<String, dynamic>),
      firmaAdi: json['firmaAdi'] as String,
      durumu: json['durumu'] as String,
      faliyetTuru: json['faliyetTuru'] as String?,
      projeKategori: json['projeKategori'] as String,
      projeAltKategori: json['projeAltKategori'] as String?,
      departmanAdi: json['departmanAdi'] as String,
      paraBirimi: json['paraBirimi'] as String,
      nakdiYuzde: (json['nakdiYuzde'] as num?)?.toDouble(),
      fizikiYuzde: (json['fizikiYuzde'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProjeLineModelToJson(ProjeLineModel instance) =>
    <String, dynamic>{
      'proje': instance.proje,
      'firmaAdi': instance.firmaAdi,
      'durumu': instance.durumu,
      'faliyetTuru': instance.faliyetTuru,
      'projeKategori': instance.projeKategori,
      'projeAltKategori': instance.projeAltKategori,
      'departmanAdi': instance.departmanAdi,
      'paraBirimi': instance.paraBirimi,
      'nakdiYuzde': instance.nakdiYuzde,
      'fizikiYuzde': instance.fizikiYuzde,
    };
