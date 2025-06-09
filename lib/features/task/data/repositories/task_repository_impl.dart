import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_list_request_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TaskListItemModel>> getTaskList(TaskListRequestModel request) async {
    var taskList = await remoteDataSource.getTaskList(request);
    return taskList;
  }
  @override
  Future<List<TaskListItemModel>> getAllTaskList() async {
    var taskList = await remoteDataSource.getAllTaskList();
    return taskList;
  }
  @override
  Future<void> updateTask(TaskRequestModel task) {
    return remoteDataSource.updateTask(task);
  }

  @override
  Future<List<TaskListItemModel>> getLastTasks(TaskListRequestModel taskListRequestModel,{int count = 10}) async {
    var taskList = await remoteDataSource.getLastTasks(taskListRequestModel, count: count);
    return taskList;
  }

}
