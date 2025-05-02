import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Task>> getTasksByProjectId(String projectId) async {
    final models = await remoteDataSource.getTasksByProjectId(projectId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Task> addTask(Task task) async {
    final taskModel = await remoteDataSource.addTask(TaskModel.fromEntity(task));
    return taskModel.toEntity();
  }

  @override
  Future<List<Task>> getTaskList(String tarih) async {
    final models = await remoteDataSource.getTaskList(tarih);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteTask(int taskId) {
    return remoteDataSource.deleteTask(taskId);
  }

  @override
  Future<void> updateTask(Task task) {
    return remoteDataSource.updateTask(TaskModel.fromEntity(task));
  }
}
