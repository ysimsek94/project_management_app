// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_adet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjeAdetModel _$ProjeAdetModelFromJson(Map<String, dynamic> json) =>
    ProjeAdetModel(
      departmanAdi: json['departmanAdi'] as String? ?? '',
      durumAdi: json['durumAdi'] as String? ?? '',
      adet: (json['adet'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProjeAdetModelToJson(ProjeAdetModel instance) =>
    <String, dynamic>{
      'departmanAdi': instance.departmanAdi,
      'durumAdi': instance.durumAdi,
      'adet': instance.adet,
    };
