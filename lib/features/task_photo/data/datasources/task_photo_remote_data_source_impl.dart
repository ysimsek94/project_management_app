import 'dart:convert';

import 'package:project_management_app/core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/task_photo_model.dart';
import 'task_photo_remote_data_source.dart';

class TaskPhotoRemoteDataSourceImpl extends BaseRemoteDataSource implements TaskPhotoRemoteDataSource {
  TaskPhotoRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<TaskPhotoModel>> getPhotos({required int fazId, required int gorevId, required bool loadImage}) async {
    final path = ApiEndpoints.getTaskImages(fazId, gorevId, loadImage);
    var result=getList<TaskPhotoModel>(
      path,
          (json) => TaskPhotoModel.fromJson(json),
      customMsgs: {
        400: 'Hatalı image sorgusu.',
        404: 'Fotoğraflar bulunamadı.',
        500: 'Sunucu hatası. Fotoğraflar alınamadı.',
      },
    );
    return result;
  }

  @override
  Future<TaskPhotoModel> uploadPhoto(TaskPhotoModel photo) async {
    print('TASK IMAGE : ${jsonEncode(photo.toJson())}');

    final response = await api.post(ApiEndpoints.addTaskImage, data: photo.toJson());
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
    final response = await api.delete(ApiEndpoints.deleteTaskImage(id));
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