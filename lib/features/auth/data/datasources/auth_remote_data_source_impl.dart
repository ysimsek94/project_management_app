import '../../../../core/network/api_service.dart';
import '../models/login_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  // @override
  // Future<LoginResponseModel> login(LoginRequestModel request) async {
  //   final response = await apiService.post(
  //     'https://yourapi.com/login',
  //     data: request.toJson(),
  //   );
  //   return LoginResponseModel.fromJson(response.data);
  // }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final Map<String, dynamic> mockJson = {
      "token": "mock-token-123",
      "username": "admin",
      "adSoyad": "Yusuf Şimşek",
      "roles": ["user"],
    };

    return LoginResponseModel.fromJson(mockJson);
  }
}