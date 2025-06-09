import 'dart:convert';

import 'package:project_management_app/features/activity_photo/data/datasources/task_photo_remote_data_source.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/activity_photo_model.dart';


class ActivityPhotoRemoteDataSourceImpl extends BaseRemoteDataSource implements ActivityPhotoRemoteDataSource {
  ActivityPhotoRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<ActivityPhotoModel>> getPhotos({required int faliyetId, required int gorevId, required bool loadImage}) async {
    final path = ApiEndpoints.getActivityImages(faliyetId, gorevId, loadImage);
    var result=getList<ActivityPhotoModel>(
      path,
          (json) => ActivityPhotoModel.fromJson(json),
      customMsgs: {
        400: 'Hatalı image sorgusu.',
        404: 'Fotoğraflar bulunamadı.',
        500: 'Sunucu hatası. Fotoğraflar alınamadı.',
      },
    );
    return result;
  }

  @override
  Future<ActivityPhotoModel> uploadPhoto(ActivityPhotoModel photo) async {
    print('TASK IMAGE : ${jsonEncode(photo.toJson())}');

    final response = await api.post(ApiEndpoints.addActivityImage, data: photo.toJson());
    final parsed = api.handleResponse<Map<String, dynamic>>(
      response,
      (json) => json as Map<String, dynamic>,
      customMessages: {
        400: 'Fotoğraf yükleme hatalı.',
        404: 'Fotoğraf kaynağı bulunamadı.',
        500: 'Sunucu hatası. Fotoğraf yüklenemedi.',
      },
    );

    final uploadedId = parsed['id'];
    return photo.copyWith(id: uploadedId is int ? uploadedId : 0);
  }

  @override
  Future<void> deletePhoto({required int id}) async {
    final response = await api.delete(ApiEndpoints.deleteActivityImage(id));
    api.handleResponse(
      response,
      (_) => null,
      customMessages: {
        400: 'Silme işlemi hatalı.',
        404: 'Fotoğraf bulunamadı.',
        500: 'Fotoğraf silinemedi.',
      },
    );
  }
}