// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskPhotoModel _$TaskPhotoModelFromJson(Map<String, dynamic> json) =>
    TaskPhotoModel(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      base64Image: json['base64Image'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$TaskPhotoModelToJson(TaskPhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'base64Image': instance.base64Image,
      'createdAt': instance.createdAt,
    };
