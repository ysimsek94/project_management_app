import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/project.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel {
  final String id;
  final String name;
  final String description;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  Project toEntity() {
    return Project(
      id: id,
      name: name,
      description: description,
    );
  }
}