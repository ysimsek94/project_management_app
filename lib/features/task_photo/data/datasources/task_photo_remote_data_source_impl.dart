import 'package:project_management_app/core/network/api_service.dart';
import '../models/task_photo_model.dart';
import 'task_photo_remote_data_source.dart';

class TaskPhotoRemoteDataSourceImpl implements TaskPhotoRemoteDataSource {
  final ApiService api;
  TaskPhotoRemoteDataSourceImpl(this.api);

  @override
  Future<List<TaskPhotoModel>> getPhotos(String taskId) async {
    // Original API call:
    // final response = await api.get('/tasks/$taskId/photos');
    // if (response.statusCode == 200) {
    //   final data = response.data as List;
    //   return data.map((e) => TaskPhotoModel.fromJson(e)).toList();
    // } else {
    //   throw Exception('Error fetching photos: ${response.statusCode}');
    // }
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock JSON data
    final String sampleBase64Png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMBAAN9HtZcAAAAAElFTkSuQmCC';
    final List<Map<String, dynamic>> mockJsonList = [
      {
        'id': '1',
        'taskId': taskId,
        'base64Image': sampleBase64Png,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'taskId': taskId,
        'base64Image': sampleBase64Png,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];
    return mockJsonList.map((json) => TaskPhotoModel.fromJson(json)).toList();
  }

  @override
  Future<TaskPhotoModel> uploadPhoto(String taskId, String base64Image) async {
    // Original API call:
    // final response = await api.post(
    //   '/tasks/$taskId/photos',
    //   data: {'image': base64Image},
    // );
    // if (response.statusCode == 200) {
    //   return TaskPhotoModel.fromJson(response.data);
    // } else {
    //   throw Exception('Error uploading photo: ${response.statusCode}');
    // }
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock JSON response for uploaded photo
    final Map<String, dynamic> mockJson = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'taskId': taskId,
      'base64Image': base64Image,
      'createdAt': DateTime.now().toIso8601String(),
    };
    return TaskPhotoModel.fromJson(mockJson);
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    // Original API call:
    // final response = await api.delete('/photos/$photoId');
    // if (response.statusCode != 200) {
    //   throw Exception('Error deleting photo: ${response.statusCode}');
    // }
    // Mock network delay for delete
    await Future.delayed(const Duration(milliseconds: 300));
    // Always succeed
    return;
  }
}