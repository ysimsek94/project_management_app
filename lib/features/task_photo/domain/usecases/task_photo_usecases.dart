/// Domain use cases for TaskPhoto feature

import '../../data/models/task_photo_model.dart';
import '../repositories/task_photo_repository.dart';

/// UseCase: Retrieve all photos for a given task
class GetTaskPhotosUseCase {
  final TaskPhotoRepository repository;
  GetTaskPhotosUseCase(this.repository);

  /// Returns a list of TaskPhoto for the specified fazId, gorevId, and loadImage
  Future<List<TaskPhotoModel>> call(int fazId, int gorevId, bool loadImage) {
    return repository.getPhotos(fazId: fazId, gorevId: gorevId,loadImage:  loadImage);
  }
}

/// UseCase: Upload a new photo to a task
class UploadTaskPhotoUseCase {
  final TaskPhotoRepository repository;
  UploadTaskPhotoUseCase(this.repository);

  /// Sends a TaskPhotoModel for upload
  /// and returns the created TaskPhoto
  Future<TaskPhotoModel> call(TaskPhotoModel photo) {
    return repository.uploadPhoto(photo);
  }
}

/// UseCase: Delete an existing photo
class DeleteTaskPhotoUseCase {
  final TaskPhotoRepository repository;
  DeleteTaskPhotoUseCase(this.repository);

  /// Deletes a photo by its id
  Future<void> call({required int id}) {
    return repository.deletePhoto(id: id);
  }
}