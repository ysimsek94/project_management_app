import 'dart:convert';
import 'dart:io';
import '../network/api_service.dart';

class PhotoUploadService {
  final ApiService apiService;

  PhotoUploadService(this.apiService);

  Future<void> uploadImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final payload = {
      'image': base64Image,
      'fileName': imageFile.path.split('/').last,
    };

    await apiService.post('/upload/photo', data: payload);
  }
}