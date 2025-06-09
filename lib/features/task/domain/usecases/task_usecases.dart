import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import 'package:project_management_app/features/task/data/models/task_list_request_model.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';

import '../repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository repository;

  TaskUseCases(this.repository);

  // Future<Task> addTask(Task task) async {
  //   return await repository.addTask(task);
  // }

  Future<List<TaskListItemModel>> getTaskList(TaskListRequestModel taskListRequestModel) async {
    return await repository.getTaskList(taskListRequestModel);
  }

  Future<List<TaskListItemModel>> getAllTaskList() async {
    return await repository.getAllTaskList();
  }

  Future<void> updateTask(TaskRequestModel task) async {
    return await repository.updateTask(task);
  }

  Future<List<TaskListItemModel>> getLastTasks(TaskListRequestModel taskListRequestModel,{int count = 10}) {
    return repository.getLastTasks(taskListRequestModel, count: count);
  }
}
