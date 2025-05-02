import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasksByProjectId(String projectId);
  Future<TaskModel> getTaskById(int taskId);
  Future<TaskModel> addTask(TaskModel task);
  Future<List<TaskModel>> getTaskList(String tarih);
  Future<void> deleteTask(int taskId);
  Future<void> updateTask(TaskModel task);
}