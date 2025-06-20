
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';

import '../repositories/map_repository.dart';

class MapUseCases {
  final MapRepository mapRepository;

  MapUseCases({required this.mapRepository});

  Future<List<TaskListItemModel>> getAllTasks() async {
    return await mapRepository.fetchAllTasks();
  }
}