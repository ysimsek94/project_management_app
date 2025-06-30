import 'api_service.dart';

abstract class BaseRemoteDataSource {
  final ApiService api;

  BaseRemoteDataSource(this.api);

  /// GET list
  Future<List<T>> getList<T>(
      String path,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, dynamic>? queryParameters,
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.get(
      path,
      queryParameters: queryParameters,
    );
    return api.handleResponse<List<T>>(
      response,
          (data) => (data as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      customMessages: customMsgs,
    );
  }
  /// GET list with post
  Future<List<T>> postList<T>(
      String path,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson, {
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.post(path, data: body);
    return api.handleResponse<List<T>>(
      response,
          (data) => (data as List).map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      customMessages: customMsgs,
    );
  }

  /// GET single item
  Future<T> getItem<T>(
      String path,
      T Function(Map<String, dynamic>) fromJson, {
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.get(path);
    return api.handleResponse<T>(
      response,
          (data) => fromJson(data as Map<String, dynamic>),
      customMessages: customMsgs,
    );
  }

  /// POST (create)
  Future<T> createItem<T>(
      String path,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson, {
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.post(path, data: body);
    return api.handleResponse<T>(
      response,
          (data) => fromJson(data as Map<String, dynamic>),
      customMessages: customMsgs,
    );
  }

  /// PUT (update)
  Future<T?> updateItem<T>(
      String path,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>)? fromJson, {
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.put(path, data: body);
    return api.handleResponse<T?>(
      response,
      (data) {
        if (data is Map<String, dynamic> && fromJson != null) {
          return fromJson(data);
        }
        return null; // For plain "OK" or empty responses
      },
      customMessages: customMsgs,
    );
  }

  /// DELETE
  Future<void> deleteItem(
      String path, {
        Map<int, String>? customMsgs,
      }) async {
    final response = await api.delete(path);
    api.handleResponse<void>(
      response,
          (_) => null,
      customMessages: customMsgs,
    );
  }
}