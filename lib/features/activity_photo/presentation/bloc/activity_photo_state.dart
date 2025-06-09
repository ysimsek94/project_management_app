
import 'package:equatable/equatable.dart';

import '../../data/models/activity_photo_model.dart';

abstract class ActivityPhotoState extends Equatable {
  const ActivityPhotoState();
  @override
  List<Object> get props => [];
}

/// Başlangıç durumu
class ActivityPhotoInitial extends ActivityPhotoState {
  const ActivityPhotoInitial();
}

/// Yükleniyor durumu
class ActivityPhotoLoading extends ActivityPhotoState {
  final List<ActivityPhotoModel> photos;
  const ActivityPhotoLoading(this.photos);

  @override
  List<Object> get props => [photos];
}

/// Fotoğraflar başarıyla alındı / güncellendi
class ActivityPhotoLoaded extends ActivityPhotoState {
  final List<ActivityPhotoModel> photos;
  const ActivityPhotoLoaded(this.photos);

  @override
  List<Object> get props => [photos];
}

/// Hata durumu
class ActivityPhotoError extends ActivityPhotoState {
  final String message;
  const ActivityPhotoError(this.message);

  @override
  List<Object> get props => [message];
}