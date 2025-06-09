// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityPhotoModel _$ActivityPhotoModelFromJson(Map<String, dynamic> json) =>
    ActivityPhotoModel(
      islemTarihi: json['islemTarihi'] as String? ?? '',
      kayitEden: json['kayitEden'] as String?,
      id: (json['id'] as num).toInt(),
      faliyetId: (json['faliyetId'] as num).toInt(),
      gorevId: (json['gorevId'] as num).toInt(),
      aciklama: json['aciklama'] as String?,
      docName: json['docName'] as String? ?? '',
      docBinary: json['docBinary'] as String? ?? '',
      thumbnailBinary: json['thumbnailBinary'] as String? ?? '',
      uzanti: json['uzanti'] as String? ?? '',
    );

Map<String, dynamic> _$ActivityPhotoModelToJson(ActivityPhotoModel instance) =>
    <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'faliyetId': instance.faliyetId,
      'gorevId': instance.gorevId,
      'aciklama': instance.aciklama,
      'docName': instance.docName,
      'docBinary': instance.docBinary,
      'thumbnailBinary': instance.thumbnailBinary,
      'uzanti': instance.uzanti,
    };
