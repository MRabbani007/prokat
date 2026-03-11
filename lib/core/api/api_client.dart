import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../config/env.dart';
import 'api_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient(SecureStorage secureStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(ApiInterceptor(secureStorage));

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
