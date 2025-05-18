import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasksByProjectId(String projectId);
  Future<Task> addTask(Task task);
  Future<List<Task>> getTaskList(String tarih);
  Future<void> deleteTask(int taskId);
  Future<void> updateTask(Task task);
  Future<List<Task>> getLastTasks({int count = 10});
}