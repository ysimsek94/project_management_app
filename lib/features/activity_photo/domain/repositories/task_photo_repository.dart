
import '../../data/models/activity_photo_model.dart';

abstract class ActivityPhotoRepository {
  /// Belirtilen faaliyet ve görev için tüm fotoğrafları getirir. Görsellerin yüklenip yüklenmeyeceği loadImage parametresi ile kontrol edilir.
  Future<List<ActivityPhotoModel>> getPhotos({
    required int faliyetId,
    required int gorevId,
    required bool loadImage,
  });

  /// Yeni bir fotoğraf yükler ve sunucunun döndürdüğü ActivityPhoto'u geri verir.
  Future<ActivityPhotoModel> uploadPhoto(ActivityPhotoModel photo);

  /// Belirtilen fotoğrafı siler.
  Future<void> deletePhoto({required int id});
}