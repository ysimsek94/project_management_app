

import 'package:project_management_app/features/map/data/datasources/map_remote_data_source.dart';
import 'package:project_management_app/features/map/data/models/proje_line_model.dart';
import 'package:project_management_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';

import '../../domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProjeLineModel>> getAllProjects() async {
    return await remoteDataSource.getAllProjects();
  }
}