
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/activity_photo_model.dart';
import '../../domain/usecases/task_photo_usecases.dart';
import 'activity_photo_state.dart';

class ActivityPhotoCubit extends Cubit<ActivityPhotoState> {
  final GetActivityPhotosUseCase _getPhotos;
  final UploadActivityPhotoUseCase _uploadPhoto;
  final DeleteActivityPhotoUseCase _deletePhoto;

  ActivityPhotoCubit(
      this._getPhotos,
      this._uploadPhoto,
      this._deletePhoto,
      ) : super(ActivityPhotoInitial());

  /// Göreve ait fotoğrafları yükler
  Future<void> loadPhotos({
    required int fazId,
    required int gorevId,
    bool loadImage = true,
  }) async {
    // Preserve existing photos
    final prevState = state;
    final List<ActivityPhotoModel> photos = prevState is ActivityPhotoLoaded
        ? List<ActivityPhotoModel>.from(prevState.photos)
        : <ActivityPhotoModel>[];

    // Loading state with current list
    emit(ActivityPhotoLoading(photos));
    try {
      final list = await _getPhotos.call(fazId, gorevId, loadImage);
      emit(ActivityPhotoLoaded(list));
    } catch (e) {
      emit(ActivityPhotoError('Fotoğraflar alınamadı: $e'));
    }
  }

  /// Yeni fotoğraf yükler, başarılıysa listeye ekler
  Future<void> upload(ActivityPhotoModel photo) async {
    // 1) Mevcut fotoğrafları al
    final prevState = state;
    final List<ActivityPhotoModel> photos = prevState is ActivityPhotoLoaded
        ? List<ActivityPhotoModel>.from(prevState.photos)
        : <ActivityPhotoModel>[];

    // 2) Loading state
    emit(ActivityPhotoLoading(photos));
    // 3) Yeni fotoğrafı yükle, listeye ekle ve yayını güncelle
    try {
      final ActivityPhotoModel created = await _uploadPhoto.call(photo);
      photos.add(created);
      emit(ActivityPhotoLoaded(photos));
    } catch (e) {
      emit(ActivityPhotoError('Fotoğraf yüklenemedi: $e'));
    }
  }

  /// Fotoğraf siler, başarılıysa listeden çıkarır
  Future<void> delete(int photoId) async {
    try {
      await _deletePhoto.call(id: photoId);
      final current = state;
      if (current is ActivityPhotoLoaded) {
        final filtered = current.photos.where((p) => p.id != photoId).toList();
        emit(ActivityPhotoLoaded(filtered));
      }
    } catch (e) {
      emit(ActivityPhotoError('Fotoğraf silinemedi: $e'));
    }
  }
}