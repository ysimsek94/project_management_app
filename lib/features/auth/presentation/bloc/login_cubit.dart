import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase(email: email, password: password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure('Giriş başarısız: ${e.toString()}'));
    }
  }
}