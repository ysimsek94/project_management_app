import 'package:project_management_app/core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiService.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    print(response.statusCode.toString());
    return apiService.handleResponse(
      response,
      (data) => LoginResponseModel.fromJson(data),
      customMessages: {
        401: 'Kullanıcı adı veya şifre hatalı.',
        400: 'İstek formatı hatalı.',
        500: 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.',
      },
    );
  }

  // @override
  // Future<LoginResponseModel> login(LoginRequestModel request) async {
  //   await Future.delayed(const Duration(milliseconds: 300));
  //
  //   final Map<String, dynamic> mockJson = {
  //     "token": "mock-token-123",
  //     "username": "admin",
  //     "adSoyad": "Yusuf Şimşek",
  //     "roles": ["user"],
  //   };
  //
  //   return LoginResponseModel.fromJson(mockJson);
  // }
}