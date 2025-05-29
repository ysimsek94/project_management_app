import '../../data/models/task_photo_model.dart';

abstract class TaskPhotoRepository {
  /// Belirtilen faz ve görev için tüm fotoğrafları getirir. Görsellerin yüklenip yüklenmeyeceği loadImage parametresi ile kontrol edilir.
  Future<List<TaskPhotoModel>> getPhotos({
    required int fazId,
    required int gorevId,
    required bool loadImage,
  });

  /// Yeni bir fotoğraf yükler ve sunucunun döndürdüğü TaskPhoto'u geri verir.
  Future<TaskPhotoModel> uploadPhoto(TaskPhotoModel photo);

  /// Belirtilen fotoğrafı siler.
  Future<void> deletePhoto({required int id});
}