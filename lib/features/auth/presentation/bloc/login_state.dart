import 'package:equatable/equatable.dart';
import 'package:project_management_app/features/auth/data/models/login_response_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel model;

  const LoginSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

/// UI’ın yönlendirilmesini sağlayan state
class LoginNavigate extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}