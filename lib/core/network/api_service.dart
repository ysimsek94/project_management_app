import 'package:dio/dio.dart';
import '../error/app_exception.dart';
import '../preferences/AppPreferences.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio, {String? baseUrl}) {
    // Eğer baseUrl geçilmişse Dio'nun baseUrl ayarı yapılır
    if (baseUrl != null) {
      dio.options.baseUrl = baseUrl;
    }
    // Allow non-2xx responses to be handled by handleResponse
    dio.options.validateStatus = (_) => true;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.sendTimeout = const Duration(seconds: 10);
    // Her istekte header’a token eklemek için interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppPreferences.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] ??= 'application/json';
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.post(
        path,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw AppException('Bilinmeyen bir hata oluştu.');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw AppException('Bilinmeyen bir hata oluştu.');
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.delete(
        path,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw AppException('Bilinmeyen bir hata oluştu.');
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.put(
        path,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw AppException('Bilinmeyen bir hata oluştu.');
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.patch(
        path,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw AppException('Bilinmeyen bir hata oluştu.');
  }
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw AppException('İstek zaman aşımına uğradı. Lütfen tekrar deneyin.');
    }
    throw AppException('Ağ hatası oluştu. ${e.message}');
  }

  T handleResponse<T>(
    Response response,
    T Function(dynamic data) parser, {
    Map<int, String>? customMessages,
  }) {
    try {
      final statusCode = response.statusCode ?? 0;

      if (statusCode == 200) {
        return parser(response.data);
      }

      if (customMessages != null && customMessages.containsKey(statusCode)) {
        throw AppException(customMessages[statusCode]!, statusCode: statusCode);
      }

      switch (statusCode) {
        case 400:
          throw AppException('Hatalı istek.', statusCode: statusCode);
        case 401:
          throw AppException('Yetkisiz erişim.', statusCode: statusCode);
        case 403:
          throw AppException('Erişim engellendi.', statusCode: statusCode);
        case 404:
          throw AppException('İçerik bulunamadı.', statusCode: statusCode);
        case 500:
          throw AppException('Sunucu hatası oluştu.', statusCode: statusCode);
        default:
          throw AppException('Bilinmeyen bir hata oluştu. [HTTP $statusCode]', statusCode: statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AppException('İstek zaman aşımına uğradı. Lütfen tekrar deneyin.');
      }
      throw AppException('Ağ hatası oluştu. ${e.message}');
    }
  }

}