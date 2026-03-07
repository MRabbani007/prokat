import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_interceptor.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio dio;

  ApiClient(SecureStorage secureStorage) {
    // 2026-Ready: Auto-detect environment to avoid connection errors
    String baseUrl = "http://localhost:4000"; // Default for iOS/Desktop

    if (!kIsWeb && Platform.isAndroid) {
      baseUrl = "http://10.0.2.2:5000"; // Specific for Android Emulator
    }

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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
