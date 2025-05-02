import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/features/project/presentation/pages/project_detail_page.dart';
import '../bloc/project_cubit.dart';
import '../bloc/project_state.dart';
import '../../domain/usecases/get_projects_usecase.dart';

class ProjectListPage extends StatelessWidget {
  final GetProjectsUseCase getProjectsUseCase;

  const ProjectListPage({super.key, required this.getProjectsUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectCubit(getProjectsUseCase)..fetchProjects(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Projeler")),
        body: BlocBuilder<ProjectCubit, ProjectState>(
          builder: (context, state) {
            if (state is ProjectLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProjectLoaded) {
              return ListView.builder(
                itemCount: state.projects.length,
                itemBuilder: (context, index) {
                  final project = state.projects[index];
                  return ListTile(
                    title: Text(project.name),
                    subtitle: Text(project.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailPage(project: project),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ProjectError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Henüz veri yok"));
          },
        ),
      ),
    );
  }
}