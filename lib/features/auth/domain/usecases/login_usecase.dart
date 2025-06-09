import 'package:project_management_app/features/auth/data/models/login_response_model.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseModel> call({required String tcKimlikNo, required String password}) async {
    return await repository.login(tcKimlikNo: tcKimlikNo, password: password);
  }
}