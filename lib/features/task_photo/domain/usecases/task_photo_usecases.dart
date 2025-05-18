/// Domain use cases for TaskPhoto feature

import '../repositories/task_photo_repository.dart';
import '../entities/task_photo.dart';

/// UseCase: Retrieve all photos for a given task
class GetTaskPhotosUseCase {
  final TaskPhotoRepository repository;
  GetTaskPhotosUseCase(this.repository);

  /// Returns a list of TaskPhoto for the specified taskId
  Future<List<TaskPhoto>> call(String taskId) {
    return repository.getPhotos(taskId);
  }
}

/// UseCase: Upload a new photo to a task
class UploadTaskPhotoUseCase {
  final TaskPhotoRepository repository;
  UploadTaskPhotoUseCase(this.repository);

  /// Sends a base64-encoded image for the given taskId
  /// and returns the created TaskPhoto
  Future<TaskPhoto> call(String taskId, String base64Image) {
    return repository.uploadPhoto(taskId, base64Image);
  }
}

/// UseCase: Delete an existing photo
class DeleteTaskPhotoUseCase {
  final TaskPhotoRepository repository;
  DeleteTaskPhotoUseCase(this.repository);

  /// Deletes a photo by its id
  Future<void> call(String photoId) {
    return repository.deletePhoto(photoId);
  }
}