

import 'package:project_management_app/features/home/data/models/proje_tamamlanma_line.dart';
import 'package:project_management_app/features/map/data/models/proje_line_model.dart';

import '../repositories/map_repository.dart';

class MapUseCases {
  final MapRepository mapRepository;

  MapUseCases({required this.mapRepository});

  Future<List<ProjeLineModel>> getAllProjects() async {
    return await mapRepository.getAllProjects();
  }
}