import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';

abstract class MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<TaskListItemModel> tasks;
  MapLoaded(this.tasks);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}