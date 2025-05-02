import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_projects_usecase.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final GetProjectsUseCase getProjectsUseCase;

  ProjectCubit(this.getProjectsUseCase) : super(ProjectInitial());

  Future<void> fetchProjects() async {
    emit(ProjectLoading());
    try {
      final projects = await getProjectsUseCase();
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectError('Projeler yüklenirken hata oluştu: ${e.toString()}'));
    }
  }
}