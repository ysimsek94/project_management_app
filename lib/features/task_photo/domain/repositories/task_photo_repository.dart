import '../entities/task_photo.dart';

abstract class TaskPhotoRepository {
  /// Bir göreve ait tüm fotoğrafları getirir.
  Future<List<TaskPhoto>> getPhotos(String taskId);

  /// Yeni bir fotoğraf yükler ve sunucunun döndürdüğü TaskPhoto'u geri verir.
  Future<TaskPhoto> uploadPhoto(String taskId, String base64Image);

  /// Belirtilen fotoğrafı siler.
  Future<void> deletePhoto(String photoId);
}