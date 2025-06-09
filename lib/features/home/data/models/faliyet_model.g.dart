// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faliyet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaliyetModel _$FaliyetModelFromJson(Map<String, dynamic> json) => FaliyetModel(
      id: (json['id'] as num).toInt(),
      departmanId: (json['departmanId'] as num).toInt(),
      faliyetTurId: (json['faliyetTurId'] as num).toInt(),
      projeId: (json['projeId'] as num?)?.toInt(),
      fazId: (json['fazId'] as num?)?.toInt(),
      islemId: (json['islemId'] as num?)?.toInt(),
      baslangicTarihi: json['baslangicTarihi'] as String,
      bitisTarihi: json['bitisTarihi'] as String?,
      mahalleId: (json['mahalleId'] as num?)?.toInt(),
      yer: json['yer'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      islem: json['islem'] as String? ?? '',
      fizikiYuzde: (json['fizikiYuzde'] as num?)?.toDouble(),
      durumId: (json['durumId'] as num?)?.toInt(),
      gorevDurumId: (json['gorevDurumId'] as num?)?.toInt(),
      geom: json['geom'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$FaliyetModelToJson(FaliyetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmanId': instance.departmanId,
      'faliyetTurId': instance.faliyetTurId,
      'projeId': instance.projeId,
      'fazId': instance.fazId,
      'islemId': instance.islemId,
      'baslangicTarihi': instance.baslangicTarihi,
      'bitisTarihi': instance.bitisTarihi,
      'mahalleId': instance.mahalleId,
      'yer': instance.yer,
      'aciklama': instance.aciklama,
      'islem': instance.islem,
      'fizikiYuzde': instance.fizikiYuzde,
      'durumId': instance.durumId,
      'gorevDurumId': instance.gorevDurumId,
      'geom': instance.geom,
    };
