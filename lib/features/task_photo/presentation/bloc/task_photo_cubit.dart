import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_photo.dart';

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
  Future<void> loadPhotos(String taskId) async {
    emit(TaskPhotoLoading());
    try {
      final list = await _getPhotos.call(taskId);
      emit(TaskPhotoLoaded(list));
    } catch (e) {
      emit(TaskPhotoError('Fotoğraflar alınamadı: $e'));
    }
  }

  /// Yeni fotoğraf yükler, başarılıysa listeye ekler
  Future<void> upload(String taskId, String base64) async {
    try {
      final TaskPhoto created = await _uploadPhoto.call(taskId, base64);
      final current = state;
      final photos = (current is TaskPhotoLoaded)
          ? List<TaskPhoto>.from(current.photos)
          : <TaskPhoto>[];
      photos.add(created);
      emit(TaskPhotoLoaded(photos));
    } catch (e) {
      emit(TaskPhotoError('Fotoğraf yüklenemedi: $e'));
    }
  }

  /// Fotoğraf siler, başarılıysa listeden çıkarır
  Future<void> delete(String photoId) async {
    try {
      await _deletePhoto.call(photoId);
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