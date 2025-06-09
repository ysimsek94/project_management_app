// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetLine _$FaliyetLineFromJson(Map<String, dynamic> json) => FaliyetLine(
      faaliyet: FaliyetModel.fromJson(json['faaliyet'] as Map<String, dynamic>),
      durumu: json['durumu'] as String? ?? '',
      faaliyetTuru: json['faaliyetTuru'] as String? ?? '',
      mahalle: json['mahalle'] as String? ?? '',
      projeAdi: json['projeAdi'] as String? ?? '',
      departmanAdi: json['departmanAdi'] as String? ?? '',
    );

Map<String, dynamic> _$FaliyetLineToJson(FaliyetLine instance) =>
    <String, dynamic>{
      'faaliyet': instance.faaliyet.toJson(),
      'durumu': instance.durumu,
      'faaliyetTuru': instance.faaliyetTuru,
      'mahalle': instance.mahalle,
      'projeAdi': instance.projeAdi,
      'departmanAdi': instance.departmanAdi,
    };
