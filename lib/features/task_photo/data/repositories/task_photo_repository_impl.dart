import '../../domain/repositories/task_photo_repository.dart';
import '../datasources/task_photo_remote_data_source.dart';
import '../models/task_photo_model.dart';

class TaskPhotoRepositoryImpl implements TaskPhotoRepository {
  final TaskPhotoRemoteDataSource remote;
  TaskPhotoRepositoryImpl(this.remote);

  @override
  Future<List<TaskPhotoModel>> getPhotos({required int fazId, required int gorevId, required bool loadImage}) async {
    final models = await remote.getPhotos(fazId: fazId, gorevId: gorevId, loadImage: loadImage);
    return models.map((m) => TaskPhotoModel(
      id: m.id,
      fazId: m.fazId,
      gorevId: m.gorevId,
      docName: m.docName,
      uzanti: m.uzanti,
      thumbnailBinary: m.thumbnailBinary,
      docBinary: m.docBinary,
      islemTarihi: DateTime.parse(m.islemTarihi).toString(),
    )).toList();
  }

  @override
  Future<TaskPhotoModel> uploadPhoto(TaskPhotoModel photo) async {
    final m = await remote.uploadPhoto(photo);
    return TaskPhotoModel(
      id: m.id,
      fazId: m.fazId,
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
