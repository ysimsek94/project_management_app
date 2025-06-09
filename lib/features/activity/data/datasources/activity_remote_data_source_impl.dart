import 'dart:convert';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/faliyet_gorev_model.dart';
import 'activity_remote_data_source.dart';

class ActivityRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ActivityRemoteDataSource {
  ActivityRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<FaliyetResponseModel>> getActivityList(
      FaliyetGorevRequestModel request) async {
    print('JSON gönderiliyor: ${jsonEncode(request.toJson())}');

    final result = await postList<FaliyetResponseModel>(
      ApiEndpoints.getActivityList,
      request.toJson(),
      (json) => FaliyetResponseModel.fromJson(json),
      customMsgs: {
        404: 'Görev listesi bulunamadı.',
        400: 'Hatalı görev sorgusu.',
        500: 'Sunucu hatası. Görev listesi alınamadı.',
      },
    );

    print('Görev listesi döndü: ${result.length} kayıt');
    return result;
  }

  @override
  Future<void> updateActivity(FaliyetGorevModel activity) {
    print('Activity UPDATE: ${jsonEncode(activity.toJson())}');

    final result = updateItem<void>(
      ApiEndpoints.updateActivity,
      activity.toJson(),
      (_) => null,
      customMsgs: {
        400: 'Görev güncelleme hatalı.',
        404: 'Görev bulunamadı.',
        500: 'Sunucu hatası. Görev güncellenemedi.',
      },
    );
    return result;
  }
}
