import '../models/task_photo_model.dart';

abstract class TaskPhotoRemoteDataSource {
  /// Fetch all photos for a task
  Future<List<TaskPhotoModel>> getPhotos({required int fazId, required int gorevId, required bool loadImage});

  /// Upload a photo and return the created model
  Future<TaskPhotoModel> uploadPhoto(TaskPhotoModel model);

  /// Delete a photo by its id
  Future<void> deletePhoto({required int id});
}
