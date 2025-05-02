import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String? dueTime;
  final double? latitude;
  final double? longitude;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.dueTime,
    this.latitude,
    this.longitude,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: status,
      dueTime: dueTime,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      dueTime: task.dueTime,
      latitude: task.latitude,
      longitude: task.longitude,
    );
  }
}