import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';
import 'package:project_management_app/features/auth/domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      // API çağrısı: kullanıcı bilgisi ve roller döner
      final user = await loginUseCase(email: email, password: password);
      // Başarılı login state’i
      emit(LoginSuccess(user));
      // Gelen token ve kullanıcı verilerini kaydet
      await _saveUserToPreferences(user);
      // UI’a yönlendirme talebi
      emit(LoginNavigate());
    } catch (e) {
      emit(LoginFailure('Giriş başarısız: ${e.toString()}'));
    }
  }

  Future<void> _saveUserToPreferences(User user) async {
    await AppPreferences.setToken(user.token);
    await AppPreferences.setUsername(user.username);
    await AppPreferences.setAdSoyad(user.adSoyad);
    await AppPreferences.setRoles(user.roles);
  }
}
