

import '../../domain/repositories/task_photo_repository.dart';
import '../datasources/task_photo_remote_data_source.dart';
import '../models/activity_photo_model.dart';

class ActivityPhotoRepositoryImpl implements ActivityPhotoRepository {
  final ActivityPhotoRemoteDataSource remote;
  ActivityPhotoRepositoryImpl(this.remote);

  @override
  Future<List<ActivityPhotoModel>> getPhotos({required int faliyetId, required int gorevId, required bool loadImage}) async {
    final models = await remote.getPhotos(faliyetId: faliyetId, gorevId: gorevId, loadImage: loadImage);
    return models.map((m) => ActivityPhotoModel(
      id: m.id,
      faliyetId: m.faliyetId,
      gorevId: m.gorevId,
      docName: m.docName,
      uzanti: m.uzanti,
      thumbnailBinary: m.thumbnailBinary,
      docBinary: m.docBinary,
      islemTarihi: DateTime.parse(m.islemTarihi).toString(),
    )).toList();
  }

  @override
  Future<ActivityPhotoModel> uploadPhoto(ActivityPhotoModel photo) async {
    final m = await remote.uploadPhoto(photo);
    return ActivityPhotoModel(
      id: m.id,
      faliyetId: m.faliyetId,
      gorevId: m.gorevId,
      docName: m.docName,
      uzanti: m.uzanti,
      thumbnailBinary: m.thumbnailBinary,
      docBinary: m.docBinary,
      islemTarihi: DateTime.parse(m.islemTarihi).toString(),
      aciklama: m.aciklama,
      kayitEden: m.kayitEden,
    );
  }

  @override
  Future<void> deletePhoto({required int id}) {
    return remote.deletePhoto(id: id);
  }
}
