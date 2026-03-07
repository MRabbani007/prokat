import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const sessionKey = "session_token";

  Future<void> saveSession(String token) async {
    await _storage.write(key: sessionKey, value: token);
  }

  Future<String?> getSession() async {
    return await _storage.read(key: sessionKey);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: sessionKey);
  }
}
