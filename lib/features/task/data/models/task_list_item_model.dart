import 'package:json_annotation/json_annotation.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';

part 'task_list_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskListItemModel {
  final TaskRequestModel projeFazGorev;
  @JsonKey(defaultValue: '')
  final String projeAdi;
  @JsonKey(defaultValue: '')
  final String fazAdi;

  TaskListItemModel(
      {
        required this.projeFazGorev,
        required this.projeAdi,
        required this.fazAdi
      });

  factory TaskListItemModel.fromJson(Map<String, dynamic> json) =>
      _$TaskListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListItemModelToJson(this);
}
