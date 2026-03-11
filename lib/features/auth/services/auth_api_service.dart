import 'package:dio/dio.dart';
import 'package:prokat/features/auth/services/auth_secure_storage.dart';
import '../models/auth_session.dart';
import '../models/auth_credentials.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<AuthSession> login(AuthCredentials credentials) async {
    try {
      late Response response;

      if (credentials is UsernamePasswordCredentials) {
        response = await dio.post(
          '/auth/login',
          data: {
            'authMethod': "PASSWORD",
            'username': credentials.username,
            'password': credentials.password,
          },
        );
      } else if (credentials is PhoneOtpCredentials) {
        response = await dio.post(
          '/auth/login/otp',
          data: {
            'authMethod': "PHONE",
            'phone': credentials.phone,
            'otp': credentials.otp,
          },
        );
      } else {
        throw Exception("Unsupported credentials type");
      }

      if (response.statusCode == 200) {
        return AuthSession.fromJson(response.data);
      }

      throw Exception("Login failed");
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthSession> register({
    required String method,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'authMethod': method,
          'username': username,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      if (response.statusCode == 200) {
        return AuthSession.fromJson(response.data);
      }

      throw Exception("Registration failed");
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> forgotPassword(String usernameOrPhone) async {
    try {
      await dio.post(
        '/auth/forgot-password',
        data: {'identifier': usernameOrPhone},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {'token': token, 'password': newPassword},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> requestOtp(String phone) async {
    try {
      final response = await dio.post(
        '/auth/request-otp',
        data: {"phone": phone},
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<AuthSession?> verifyOtp(String phone, String otp) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {"phone": phone, "otp": otp},
      );

      if (response.statusCode == 200) {
        final session = response.data;

        if (session != null) {
          await AuthSecureStorage().saveSession(session);
        }

        return session;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await dio.post('/auth/logout');
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return Exception(data['message']);
      }

      return Exception("Server error (${e.response?.statusCode})");
    }

    return Exception("Network error");
  }
}
