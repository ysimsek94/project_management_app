

import 'package:project_management_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';

import '../../domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final TaskRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskListItemModel>> fetchAllTasks() async {
    return await remoteDataSource.getAllTaskList();
  }
}