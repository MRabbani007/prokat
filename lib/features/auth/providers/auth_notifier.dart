import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/models/auth_session.dart';
import 'package:prokat/features/auth/services/auth_secure_storage.dart';
import '../models/auth_credentials.dart';
import '../services/auth_api_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService api;
  final AuthSecureStorage storage;

  AuthNotifier(this.api, this.storage) : super(const AuthState()) {
    _restoreSession();
  }

  /// Restore token from secure storage
  Future<void> _restoreSession() async {
    final session = await storage.readSession();

    if (session != null && session.sessionToken.isNotEmpty) {
      state = state.copyWith(session: session);
    }
  }

  /// LOGIN WITH USERNAME/PASSWORD
  Future<bool> login(AuthCredentials credentials) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await api.login(credentials);

      /// Save token string
      await storage.saveSession(session);

      state = state.copyWith(session: session, isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login failed');
      return false;
    }
  }

  /// REGISTER USER
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

      /// Save token
      await storage.saveSession(session);

      state = state.copyWith(session: session, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Registration failed');
    }
  }

  /// REQUEST OTP
  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await api.requestOtp(phone);

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Failed to request OTP");
      return false;
    }
  }

  /// VERIFY OTP
  Future<AuthSession?> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await api.verifyOtp(phone, otp);
      if (session != null) {
        await storage.saveSession(session);
      }

      // state = state.copyWith(session: token, isLoading: false);

      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Invalid OTP");
      return null;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      await api.logout();

      await storage.clearSession();

      state = const AuthState();
    } catch (e) {
      await storage.clearSession();
      state = const AuthState();
    }
  }
}
