import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

/// Global Dio interceptor
/// Handles:
/// - attaching session token
/// - logging requests
/// - handling unauthorized responses
class ApiInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  ApiInterceptor(this.secureStorage);

  /// Attach session token to every request
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorage.getSession();

      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }

      // JSON headers
      options.headers["Content-Type"] = "application/json";
      options.headers["Accept"] = "application/json";

      handler.next(options);
    } catch (e) {
      handler.next(options);
    }
  }

  /// Handle responses
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// Handle errors globally
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // Handle session expiration
    if (statusCode == 401) {
      await secureStorage.clearSession();
    }

    handler.next(err);
  }
}
