import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu
class TaskInitial extends TaskState {}

/// Herhangi bir CRUD işlemi (listeleme, create/update/delete) başlatıldığında
class TaskLoadInProgress extends TaskState {}

/// Listeleme başarılı olduğunda
class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;
  const TaskLoadSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// CRUD operasyonu başarılı olduğunda (create, update, delete ortak loading)
class TaskOperationInProgress extends TaskState {}

/// Yeni görev oluşturma başarılı
class TaskCreateSuccess extends TaskState {
  final Task task;
  const TaskCreateSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

/// Görev güncelleme başarılı
class TaskUpdateSuccess extends TaskState {
  final String message;
  const TaskUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Görev silme başarılı
class TaskDeleteSuccess extends TaskState {
  final int deletedTaskId;
  const TaskDeleteSuccess(this.deletedTaskId);

  @override
  List<Object?> get props => [deletedTaskId];
}

/// Hata durumu (listeleme de dahil tüm adımlarda kullanabilirsiniz)
class TaskFailure extends TaskState {
  final String message;
  const TaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}