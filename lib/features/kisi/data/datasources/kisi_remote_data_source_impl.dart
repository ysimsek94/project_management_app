import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/kisi_model.dart';
import 'kisi_remote_data_source.dart';

class KisiRemoteDataSourceImpl extends BaseRemoteDataSource
    implements KisiRemoteDataSource {
  KisiRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<KisiModel>> getKisiList() async {

    final result = await getList<KisiModel>(
      ApiEndpoints.getAllKisiler,
          (json) => KisiModel.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Kişi listesi bulunamadı.',
        400: 'Hatalı kişi sorgusu.',
        500: 'Sunucu hatası. Kişi listesi alınamadı.',
      },
    );
    print('Gelen kişi sayısı: ${result.length}');
    return result;
  }
}
