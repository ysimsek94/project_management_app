import 'package:equatable/equatable.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu
class ActivityInitial extends ActivityState {}

/// Herhangi bir CRUD işlemi (listeleme, create/update/delete) başlatıldığında
class ActivityLoadInProgress extends ActivityState {}

/// Listeleme başarılı olduğunda
class ActivityLoadSuccess extends ActivityState {
  final List<FaliyetResponseModel> activities;
  const ActivityLoadSuccess(this.activities);

  @override
  List<Object?> get props => [activities];
}

/// CRUD operasyonu başarılı olduğunda (create, update, delete ortak loading)
class ActivityOperationInProgress extends ActivityState {}

/// Yeni görev oluşturma başarılı
class ActivityCreateSuccess extends ActivityState {
  final FaliyetGorevModel activity;
  const ActivityCreateSuccess(this.activity);

  @override
  List<Object?> get props => [activity];
}

/// Görev güncelleme başarılı
class ActivityUpdateSuccess extends ActivityState {
  final String message;
  const ActivityUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Görev silme başarılı
class ActivityDeleteSuccess extends ActivityState {
  final int deletedActivityId;
  const ActivityDeleteSuccess(this.deletedActivityId);

  @override
  List<Object?> get props => [deletedActivityId];
}

/// Hata durumu (listeleme de dahil tüm adımlarda kullanabilirsiniz)
class ActivityFailure extends ActivityState {
  final String message;
  const ActivityFailure(this.message);

  @override
  List<Object?> get props => [message];
}