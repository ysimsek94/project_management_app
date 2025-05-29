import 'package:equatable/equatable.dart';
import '../../data/models/task_photo_model.dart';

abstract class TaskPhotoState extends Equatable {
  const TaskPhotoState();
  @override
  List<Object> get props => [];
}

/// Başlangıç durumu
class TaskPhotoInitial extends TaskPhotoState {
  const TaskPhotoInitial();
}

/// Yükleniyor durumu
class TaskPhotoLoading extends TaskPhotoState {
  final List<TaskPhotoModel> photos;
  const TaskPhotoLoading(this.photos);

  @override
  List<Object> get props => [photos];
}

/// Fotoğraflar başarıyla alındı / güncellendi
class TaskPhotoLoaded extends TaskPhotoState {
  final List<TaskPhotoModel> photos;
  const TaskPhotoLoaded(this.photos);

  @override
  List<Object> get props => [photos];
}

/// Hata durumu
class TaskPhotoError extends TaskPhotoState {
  final String message;
  const TaskPhotoError(this.message);

  @override
  List<Object> get props => [message];
}