import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksByProjectIdUseCase {
  final TaskRepository repository;

  GetTasksByProjectIdUseCase(this.repository);

  Future<List<Task>> call(String projectId) async {
    return await repository.getTasksByProjectId(projectId);
  }
}