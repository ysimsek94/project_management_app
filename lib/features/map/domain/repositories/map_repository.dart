import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';

abstract class MapRepository {
  Future<List<TaskListItemModel>> fetchAllTasks();
}
