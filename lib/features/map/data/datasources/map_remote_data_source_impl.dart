import 'package:project_management_app/features/map/data/models/proje_line_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import 'map_remote_data_source.dart';

class MapRemoteDataSourceImpl extends BaseRemoteDataSource implements MapRemoteDataSource {
  MapRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<ProjeLineModel>> getAllProjects() async {
    final result = await postList<ProjeLineModel>(
      ApiEndpoints.getAllProje,
      {},
      (json) => ProjeLineModel.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Proje listesi bulunamadı.',
        400: 'Hatalı proje sorgusu.',
        500: 'Sunucu hatası. Proje listesi alınamadı.',
      },
    );
    return result;
  }
}