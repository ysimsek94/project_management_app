
import '../../data/models/activity_photo_model.dart';
import '../repositories/task_photo_repository.dart';

/// UseCase: Retrieve all photos for a given task
class GetActivityPhotosUseCase {
  final ActivityPhotoRepository repository;
  GetActivityPhotosUseCase(this.repository);

  /// Returns a list of ActivityPhoto for the specified fazId, gorevId, and loadImage
  Future<List<ActivityPhotoModel>> call(int faliyetId, int gorevId, bool loadImage) {
    return repository.getPhotos(faliyetId: faliyetId, gorevId: gorevId,loadImage:  loadImage);
  }
}

/// UseCase: Upload a new photo to a task
class UploadActivityPhotoUseCase {
  final ActivityPhotoRepository repository;
  UploadActivityPhotoUseCase(this.repository);

  /// Sends a ActivityPhotoModel for upload
  /// and returns the created ActivityPhoto
  Future<ActivityPhotoModel> call(ActivityPhotoModel photo) {
    return repository.uploadPhoto(photo);
  }
}

/// UseCase: Delete an existing photo
class DeleteActivityPhotoUseCase {
  final ActivityPhotoRepository repository;
  DeleteActivityPhotoUseCase(this.repository);

  /// Deletes a photo by its id
  Future<void> call({required int id}) {
    return repository.deletePhoto(id: id);
  }
}