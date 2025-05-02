import '../../../../core/network/api_service.dart';
import '../models/project_model.dart';
import 'project_remote_data_source.dart';

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiService apiService;

  ProjectRemoteDataSourceImpl(this.apiService);

  // @override
  // Future<List<ProjectModel>> getProjects() async {
  //   final response = await apiService.get('https://yourapi.com/projects');
  //   final List<dynamic> data = response.data;
  //   return data.map((item) => ProjectModel.fromJson(item)).toList();
  // }
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simüle edilen gecikme

    return [
      ProjectModel(id: '1', name: 'CRM Sistemi', description: 'Müşteri yönetim modülü'),
      ProjectModel(id: '2', name: 'E-Fatura', description: 'Fatura entegrasyonu projesi'),
    ];
  }
}