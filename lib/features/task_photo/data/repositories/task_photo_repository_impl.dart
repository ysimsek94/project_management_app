import '../../domain/entities/task_photo.dart';
import '../../domain/repositories/task_photo_repository.dart';
import '../datasources/task_photo_remote_data_source.dart';

class TaskPhotoRepositoryImpl implements TaskPhotoRepository {
  final TaskPhotoRemoteDataSource remote;
  TaskPhotoRepositoryImpl(this.remote);

  @override
  Future<List<TaskPhoto>> getPhotos(String taskId) async {
    final models = await remote.getPhotos(taskId);
    return models
        .map((m) => TaskPhoto(
      id: m.id,
      taskId: m.taskId,
      base64Image: m.base64Image,
      createdAt: DateTime.parse(m.createdAt),
    ))
        .toList();
  }

  @override
  Future<TaskPhoto> uploadPhoto(String taskId, String base64Image) async {
    final model = await remote.uploadPhoto(taskId, base64Image);
    return TaskPhoto(
      id: model.id,
      taskId: model.taskId,
      base64Image: model.base64Image,
      createdAt: DateTime.parse(model.createdAt),
    );
  }

  @override
  Future<void> deletePhoto(String photoId) {
    return remote.deletePhoto(photoId);
  }
}
