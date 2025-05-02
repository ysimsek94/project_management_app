import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<List<Project>> call() async {
    return await repository.getProjects();
  }
}