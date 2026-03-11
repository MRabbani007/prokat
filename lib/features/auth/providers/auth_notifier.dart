import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_credentials.dart';
import '../services/auth_api_service.dart';
import '../services/auth_secure_storage.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService api;
  final AuthSecureStorage storage;

  AuthNotifier(this.api, this.storage) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final session = await storage.readSession();
    if (session != null) {
      state = state.copyWith(session: session);
    }
  }

  Future<void> login(AuthCredentials credentials) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await api.login(credentials);
      await storage.saveSession(session);
      state = state.copyWith(session: session, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login failed');
    }
  }

  Future<void> register(
    String method,
    String username,
    String password,
    String firstName,
    String lastName,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await api.register(
        method: method,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      await storage.saveSession(session);
      state = state.copyWith(session: session, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Registration failed');
    }
  }

  Future<void> logout() async {
    await storage.clearSession();
    state = const AuthState();
  }
}
