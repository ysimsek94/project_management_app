import 'package:project_management_app/features/auth/data/models/login_response_model.dart';


abstract class AuthRepository {
  Future<LoginResponseModel> login({required String tcKimlikNo, required String password});
}