import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() {
    return "ApiException: $message (statusCode: $statusCode)";
  }

  /// Convert DioException into ApiException
  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ApiException.badRequest(data);

      case 401:
        return ApiException.unauthorized(data);

      case 403:
        return ApiException.forbidden(data);

      case 404:
        return ApiException.notFound(data);

      case 409:
        return ApiException.conflict(data);

      case 422:
        return ApiException.validation(data);

      case 500:
      case 502:
      case 503:
        return ApiException.serverError(data);

      default:
        return ApiException(
          message: error.message ?? "Unknown error",
          statusCode: statusCode,
          data: data,
        );
    }
  }

  /// Factories

  factory ApiException.badRequest(dynamic data) {
    return ApiException(message: "Bad request", statusCode: 400, data: data);
  }

  factory ApiException.unauthorized(dynamic data) {
    return ApiException(message: "Unauthorized", statusCode: 401, data: data);
  }

  factory ApiException.forbidden(dynamic data) {
    return ApiException(message: "Forbidden", statusCode: 403, data: data);
  }

  factory ApiException.notFound(dynamic data) {
    return ApiException(
      message: "Resource not found",
      statusCode: 404,
      data: data,
    );
  }

  factory ApiException.conflict(dynamic data) {
    return ApiException(message: "Conflict", statusCode: 409, data: data);
  }

  factory ApiException.validation(dynamic data) {
    return ApiException(
      message: "Validation error",
      statusCode: 422,
      data: data,
    );
  }

  factory ApiException.serverError(dynamic data) {
    return ApiException(message: "Server error", statusCode: 500, data: data);
  }

  factory ApiException.network() {
    return ApiException(
      message: "Network error. Please check your connection.",
    );
  }
}
