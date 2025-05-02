import 'package:equatable/equatable.dart';

abstract class AddTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {}

class AddTaskError extends AddTaskState {
  final String message;

  AddTaskError(this.message);

  @override
  List<Object?> get props => [message];
}