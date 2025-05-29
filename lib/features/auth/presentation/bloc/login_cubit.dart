import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';
import 'package:project_management_app/features/auth/data/models/login_response_model.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String tcKimlikNo, String password) async {
    emit(LoginLoading());
    try {
      // API çağrısı: tcKimlikNo ve roller döner
      final loginResponseModel = await loginUseCase(tcKimlikNo: tcKimlikNo, password: password);
      // Başarılı login state’i
      emit(LoginSuccess(loginResponseModel));
      // Gelen token ve kullanıcı verilerini kaydet
      await _saveUserToPreferences(loginResponseModel);
      // UI’a yönlendirme talebi
      emit(LoginNavigate());
    } on AppException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure('Beklenmeyen bir hata oluştu.'));
    }
  }

  Future<void> _saveUserToPreferences(LoginResponseModel model) async {
    await AppPreferences.setToken(model.token);
    await AppPreferences.setUsername(model.username);
    await AppPreferences.setKullaniciId(model.kullaniciId);
    await AppPreferences.setRoles(model.rolList);
  }
}
