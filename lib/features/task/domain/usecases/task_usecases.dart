import '../repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskUseCases {
  final TaskRepository repository;

  TaskUseCases(this.repository);

  Future<Task> addTask(Task task) async {
    return await repository.addTask(task);
  }

  Future<List<Task>> getTaskList(String tarih) async {
    return await repository.getTaskList(tarih);
  }

  Future<void> deleteTask(int taskId) async {
    return await repository.deleteTask(taskId);
  }

  Future<void> updateTask(Task task) async {
    return await repository.updateTask(task);
  }

  Future<List<Task>> getLastTasks({int count = 10}) {
    return repository.getLastTasks(count: count);
  }
}
