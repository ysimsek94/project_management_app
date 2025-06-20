

import '../models/activity_photo_model.dart';

abstract class ActivityPhotoRemoteDataSource {
  /// Fetch all photos for a activity
  Future<List<ActivityPhotoModel>> getPhotos({required int faliyetId, required int gorevId, required bool loadImage});

  /// Upload a photo and return the created models
  Future<ActivityPhotoModel> uploadPhoto(ActivityPhotoModel model);

  /// Delete a photo by its id
  Future<void> deletePhoto({required int id});
}
