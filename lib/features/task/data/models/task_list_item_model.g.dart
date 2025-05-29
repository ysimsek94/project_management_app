// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskListItemModel _$TaskListItemModelFromJson(Map<String, dynamic> json) =>
    TaskListItemModel(
      projeFazGorev: TaskRequestModel.fromJson(
          json['projeFazGorev'] as Map<String, dynamic>),
      projeAdi: json['projeAdi'] as String? ?? '',
      fazAdi: json['fazAdi'] as String? ?? '',
    );

Map<String, dynamic> _$TaskListItemModelToJson(TaskListItemModel instance) =>
    <String, dynamic>{
      'projeFazGorev': instance.projeFazGorev.toJson(),
      'projeAdi': instance.projeAdi,
      'fazAdi': instance.fazAdi,
    };
