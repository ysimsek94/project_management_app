import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_photo_model.dart';
import '../../domain/usecases/task_photo_usecases.dart';
import 'task_photo_state.dart';

class TaskPhotoCubit extends Cubit<TaskPhotoState> {
  final GetTaskPhotosUseCase _getPhotos;
  final UploadTaskPhotoUseCase _uploadPhoto;
  final DeleteTaskPhotoUseCase _deletePhoto;

  TaskPhotoCubit(
      this._getPhotos,
      this._uploadPhoto,
      this._deletePhoto,
      ) : super(TaskPhotoInitial());

  /// Göreve ait fotoğrafları yükler
  Future<void> loadPhotos({
    required int fazId,
    required int gorevId,
    bool loadImage = true,
  }) async {
    // Preserve existing photos
    final prevState = state;
    final List<TaskPhotoModel> photos = prevState is TaskPhotoLoaded
        ? List<TaskPhotoModel>.from(prevState.photos)
        : <TaskPhotoModel>[];

    // Loading state with current list
    emit(TaskPhotoLoading(photos));
    try {
      final list = await _getPhotos.call(fazId, gorevId, loadImage);
      emit(TaskPhotoLoaded(list));
    } catch (e) {
      emit(TaskPhotoError('Fotoğraflar alınamadı: $e'));
    }
  }

  /// Yeni fotoğraf yükler, başarılıysa listeye ekler
  Future<void> upload(TaskPhotoModel photo) async {
    // 1) Mevcut fotoğrafları al
    final prevState = state;
    final List<TaskPhotoModel> photos = prevState is TaskPhotoLoaded
        ? List<TaskPhotoModel>.from(prevState.photos)
        : <TaskPhotoModel>[];

    // 2) Loading state
    emit(TaskPhotoLoading(photos));
    // 3) Yeni fotoğrafı yükle, listeye ekle ve yayını güncelle
    try {
      final TaskPhotoModel created = await _uploadPhoto.call(photo);
      photos.add(created);
      emit(TaskPhotoLoaded(photos));
    } catch (e) {
      emit(TaskPhotoError('Fotoğraf yüklenemedi: $e'));
    }
  }

  /// Fotoğraf siler, başarılıysa listeden çıkarır
  Future<void> delete(int photoId) async {
    try {
      await _deletePhoto.call(id: photoId);
      final current = state;
      if (current is TaskPhotoLoaded) {
        final filtered = current.photos.where((p) => p.id != photoId).toList();
        emit(TaskPhotoLoaded(filtered));
      }
    } catch (e) {
      emit(TaskPhotoError('Fotoğraf silinemedi: $e'));
    }
  }
}