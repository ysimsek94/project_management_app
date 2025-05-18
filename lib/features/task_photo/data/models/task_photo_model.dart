import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task_photo.dart';

part 'task_photo_model.g.dart';

/// JSON-serializable model for TaskPhoto entity
@JsonSerializable()
class TaskPhotoModel {
  final String id;
  final String taskId;
  @JsonKey(name: 'base64Image')
  final String base64Image;
  final String createdAt; // ISO 8601 formatted string

  TaskPhotoModel({
    required this.id,
    required this.taskId,
    required this.base64Image,
    required this.createdAt,
  });

  /// Deserialize from JSON
  factory TaskPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$TaskPhotoModelFromJson(json);

  /// Serialize to JSON
  Map<String, dynamic> toJson() => _$TaskPhotoModelToJson(this);

  /// Convert this model to domain entity
  TaskPhoto toEntity() {
    return TaskPhoto(
      id: id,
      taskId: taskId,
      base64Image: base64Image,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Create a model from domain entity
  factory TaskPhotoModel.fromEntity(TaskPhoto photo) {
    return TaskPhotoModel(
      id: photo.id,
      taskId: photo.taskId,
      base64Image: photo.base64Image,
      createdAt: photo.createdAt.toIso8601String(),
    );
  }
}