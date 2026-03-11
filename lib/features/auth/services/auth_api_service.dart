import 'package:dio/dio.dart';
import '../models/auth_session.dart';
import '../models/auth_credentials.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<AuthSession> login(AuthCredentials credentials) async {
    late Response response;

    if (credentials is UsernamePasswordCredentials) {
      response = await dio.post(
        '/auth/login',
        data: {
          'username': credentials.username,
          'password': credentials.password,
        },
      );
    } else if (credentials is PhoneOtpCredentials) {
      response = await dio.post(
        '/auth/login/otp',
        data: {'phone': credentials.phone, 'otp': credentials.otp},
      );
    }

    return AuthSession.fromJson(response.data);
  }

  Future<AuthSession> register({
    required String method,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'method': method,
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );

    return AuthSession.fromJson(response.data);
  }

  Future<void> forgotPassword(String usernameOrPhone) async {
    await dio.post(
      '/auth/forgot-password',
      data: {'identifier': usernameOrPhone},
    );
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await dio.post(
      '/auth/reset-password',
      data: {'token': token, 'password': newPassword},
    );
  }
}
