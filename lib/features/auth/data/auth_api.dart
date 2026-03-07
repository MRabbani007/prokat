import 'package:dio/dio.dart';
import '../models/auth_session.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<void> requestOtp(String phone) async {
    await dio.post("/auth/request-otp", data: {"phone": phone});
  }

  Future<AuthSession> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final res = await dio.post(
      "/auth/verify-otp",
      data: {"phone": phone, "otp": otp},
    );

    return AuthSession.fromJson(res.data);
  }

  Future<AuthSession> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final res = await dio.post(
      "/auth/register",
      data: {
        "username": username,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
      },
    );

    return AuthSession.fromJson(res.data);
  }

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final res = await dio.post(
      "/auth/login",
      data: {"username": username, "password": password},
    );

    return AuthSession.fromJson(res.data);
  }

  Future<void> logout() async {
    await dio.post("/auth/logout");
  }

  Future<void> forgotPassword(String username) async {
    await dio.post("/auth/forgot-password", data: {"username": username});
  }

  Future<AuthSession> refresh() async {
    final res = await dio.post("/auth/refresh");
    return AuthSession.fromJson(res.data);
  }

  Future<AuthSession> checkSession() async {
    final res = await dio.get("/auth/session");
    return AuthSession.fromJson(res.data);
  }
}
