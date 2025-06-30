// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_tamamlanma_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjeTamamlanmaLine _$ProjeTamamlanmaLineFromJson(Map<String, dynamic> json) =>
    ProjeTamamlanmaLine(
      departmanId: (json['departmanId'] as num).toInt(),
      departmanAdi: json['departmanAdi'] as String,
      projeAdi: json['projeAdi'] as String?,
      kategoriAdi: json['kategoriAdi'] as String?,
      toplamProjeTutari: (json['toplamProjeTutari'] as num).toDouble(),
      gerceklesenNakdiYuzde: (json['gerceklesenNakdiYuzde'] as num).toDouble(),
      gerceklesenFizikiYuzde:
          (json['gerceklesenFizikiYuzde'] as num).toDouble(),
    );

Map<String, dynamic> _$ProjeTamamlanmaLineToJson(
        ProjeTamamlanmaLine instance) =>
    <String, dynamic>{
      'departmanId': instance.departmanId,
      'departmanAdi': instance.departmanAdi,
      'projeAdi': instance.projeAdi,
      'kategoriAdi': instance.kategoriAdi,
      'toplamProjeTutari': instance.toplamProjeTutari,
      'gerceklesenNakdiYuzde': instance.gerceklesenNakdiYuzde,
      'gerceklesenFizikiYuzde': instance.gerceklesenFizikiYuzde,
    };
