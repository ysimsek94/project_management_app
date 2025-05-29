import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import 'package:project_management_app/features/task/data/models/task_list_request_model.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';

abstract class TaskRepository {
  // Future<List<Task>> getTasksByProjectId(String projectId);
  // Future<Task> addTask(Task task);
  Future<List<TaskListItemModel>> getTaskList(TaskListRequestModel taskListRequestModel);
  Future<void> updateTask(TaskRequestModel task);
  Future<List<TaskListItemModel>> getLastTasks(TaskListRequestModel taskListRequestModel,{int count = 10});
}