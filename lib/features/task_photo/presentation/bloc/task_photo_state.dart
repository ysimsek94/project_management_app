import '../../domain/entities/task_photo.dart';

abstract class TaskPhotoState {}

/// Başlangıç durumu
class TaskPhotoInitial extends TaskPhotoState {}

/// Yükleniyor durumu
class TaskPhotoLoading extends TaskPhotoState {}

/// Fotoğraflar başarıyla alındı / güncellendi
class TaskPhotoLoaded extends TaskPhotoState {
  final List<TaskPhoto> photos;
  TaskPhotoLoaded(this.photos);
}

/// Hata durumu
class TaskPhotoError extends TaskPhotoState {
  final String message;
  TaskPhotoError(this.message);
}