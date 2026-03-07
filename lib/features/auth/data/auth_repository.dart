import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prokat/features/auth/data/auth_api.dart';
import '../models/auth_session.dart';

class AuthRepository {
  final AuthApi api;
  final FlutterSecureStorage storage;

  static const _sessionKey = "auth_session";

  AuthRepository({required this.api, required this.storage});

  Future<AuthSession> register({
    required String username,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final res = await api.register(
      username: username,
      password: password,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
    );

    final session = AuthSession.fromJson(res as Map<String, dynamic>);

    await _saveSession(session);

    return session;
  }

  /// LOGIN (username + password)
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final session = await api.login(username: username, password: password);

    await _saveSession(session);
    return session;
  }

  /// VERIFY OTP
  Future<AuthSession> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final session = await api.verifyOtp(phone: phone, otp: otp);

    await _saveSession(session);
    return session;
  }

  /// REQUEST OTP
  Future<void> requestOtp(String phone) {
    return api.requestOtp(phone);
  }

  /// FORGOT PASSWORD
  Future<void> forgotPassword(String username) {
    return api.forgotPassword(username);
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {}

    await storage.delete(key: _sessionKey);
  }

  /// RESTORE SESSION (app startup)
  Future<AuthSession?> restoreSession() async {
    final raw = await storage.read(key: _sessionKey);

    if (raw == null) return null;

    final json = jsonDecode(raw);
    final session = AuthSession.fromJson(json);

    if (session.expires != null && session.expires!.isBefore(DateTime.now())) {
      return await _refreshSession();
    }

    return session;
  }

  /// REFRESH SESSION
  Future<AuthSession?> _refreshSession() async {
    try {
      final session = await api.refresh();
      await _saveSession(session);
      return session;
    } catch (_) {
      await storage.delete(key: _sessionKey);
      return null;
    }
  }

  /// SAVE SESSION
  Future<void> _saveSession(AuthSession session) async {
    await storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
  }
}
