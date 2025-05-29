// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskPhotoModel _$TaskPhotoModelFromJson(Map<String, dynamic> json) =>
    TaskPhotoModel(
      islemTarihi: json['islemTarihi'] as String? ?? '',
      kayitEden: json['kayitEden'] as String?,
      id: (json['id'] as num).toInt(),
      fazId: (json['fazId'] as num).toInt(),
      gorevId: (json['gorevId'] as num).toInt(),
      aciklama: json['aciklama'] as String?,
      docName: json['docName'] as String? ?? '',
      docBinary: json['docBinary'] as String? ?? '',
      thumbnailBinary: json['thumbnailBinary'] as String? ?? '',
      uzanti: json['uzanti'] as String? ?? '',
    );

Map<String, dynamic> _$TaskPhotoModelToJson(TaskPhotoModel instance) =>
    <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'fazId': instance.fazId,
      'gorevId': instance.gorevId,
      'aciklama': instance.aciklama,
      'docName': instance.docName,
      'docBinary': instance.docBinary,
      'thumbnailBinary': instance.thumbnailBinary,
      'uzanti': instance.uzanti,
    };
