import 'package:project_management_app/features/map/data/models/proje_line_model.dart';

abstract class MapRemoteDataSource {
  Future<List<ProjeLineModel>> getAllProjects();
}

