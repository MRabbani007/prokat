import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_session.dart';

class AuthSecureStorage {
  static const _key = 'auth_session';

  final _storage = const FlutterSecureStorage();

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _key, value: jsonEncode(session.toJson()));
  }

  Future<AuthSession?> readSession() async {
    final value = await _storage.read(key: _key);
    if (value == null) return null;

    return AuthSession.fromJson(jsonDecode(value));
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _key);
  }
}
