import 'package:dio/dio.dart';
import 'package:prokat/features/auth/services/auth_secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final AuthSecureStorage secureStorage;

  ApiInterceptor(this.secureStorage);

  /// Attach auth token
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final session = await secureStorage.readSession();

      print("TOKEN: ${session?.sessionToken}");
      if (session != null) {
        final token = session.sessionToken;

        options.headers["Authorization"] = "Bearer $token";
      }

      options.headers.putIfAbsent("Content-Type", () => "application/json");
      options.headers.putIfAbsent("Accept", () => "application/json");

      handler.next(options);
    } catch (_) {
      handler.next(options);
    }
  }

  /// Handle successful responses
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// Global error handler
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    /// Session expired
    if (statusCode == 401) {
      await secureStorage.clearSession();
    }

    /// Extract backend error message
    String message = "Something went wrong";

    if (data is Map && data["message"] != null) {
      message = data["message"];
    } else if (statusCode == 500) {
      message = "Server error";
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      message = "Connection timeout";
    } else if (err.type == DioExceptionType.connectionError) {
      message = "Network error";
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
      ),
    );
  }
}
