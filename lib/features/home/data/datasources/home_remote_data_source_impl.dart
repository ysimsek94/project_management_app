import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/status_summary_model.dart';
import 'home_remote_data_source.dart';


class HomeRemoteDataSourceImpl extends BaseRemoteDataSource implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(ApiService apiService) : super(apiService);



  @override
  Future<List<StatusSummaryModel>> fetchStatusSummary() {
    var result=getList<StatusSummaryModel>(
      ApiEndpoints.getStatusSummary,
          (json) => StatusSummaryModel.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Durum özetleri bulunamadı.',
        400: 'Hatalı özet sorgusu.',
        500: 'Sunucu hatası. Özetler alınamadı.',
      },
    );
    return result;
  }
  @override
  Future<List<StatusSummaryModel>> fetchFaliyetStatusSummary() async {
    var result=getList<StatusSummaryModel>(
      ApiEndpoints.getActvityDurumAdet,
          (json) => StatusSummaryModel.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Durum özetleri bulunamadı.',
        400: 'Hatalı özet sorgusu.',
        500: 'Sunucu hatası. Özetler alınamadı.',
      },
    );
    return result;
  }
}