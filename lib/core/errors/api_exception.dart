import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  bool get isAuthError => statusCode == 401;

  static String _extractMessage(dynamic data, String fallback) {
    if (data is Map && data["message"] != null) {
      return data["message"];
    }
    return fallback;
  }

  @override
  String toString() {
    return "ApiException: $message (statusCode: $statusCode)";
  }

  /// Convert DioException into ApiException
  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: "Connection timeout");

      case DioExceptionType.connectionError:
        return ApiException.network();

      case DioExceptionType.badResponse:
        break; // continue to statusCode switch

      case DioExceptionType.cancel:
        return ApiException(message: "Request cancelled");

      default:
        return ApiException(message: error.message ?? "Unknown network error");
    }

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

  // Factories

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
    return ApiException(
      message: _extractMessage(data, "Conflict"),
      statusCode: 409,
      data: data,
    );
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
