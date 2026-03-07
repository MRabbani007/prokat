class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? message;

  ApiResponse({this.data, required this.success, this.message});

  /// Success response
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(data: data, success: true, message: message);
  }

  /// Error response
  factory ApiResponse.error(String message) {
    return ApiResponse<T>(success: false, message: message);
  }
}
