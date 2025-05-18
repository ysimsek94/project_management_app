import '../models/task_photo_model.dart';

abstract class TaskPhotoRemoteDataSource {
  /// Fetch all photos for a task
  Future<List<TaskPhotoModel>> getPhotos(String taskId);

  /// Upload a photo and return the created model
  Future<TaskPhotoModel> uploadPhoto(String taskId, String base64Image);

  /// Delete a photo by its id
  Future<void> deletePhoto(String photoId);
}
