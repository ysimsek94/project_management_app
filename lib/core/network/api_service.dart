import 'package:dio/dio.dart';
import '../preferences/AppPreferences.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio, {String? baseUrl}) {
    // Eğer baseUrl geçilmişse Dio'nun baseUrl ayarı yapılır
    if (baseUrl != null) {
      dio.options.baseUrl = baseUrl;
    }
    // Her istekte header’a token eklemek için interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppPreferences.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

// Eğer gerekirse put, delete vs. de eklenebilir.
}