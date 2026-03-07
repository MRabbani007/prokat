import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/data/auth_repository.dart';
import 'package:prokat/features/auth/providers/auth_repository_provider.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository)
    : super(const AuthState(status: AuthStatus.unknown));

  /// Initialize app session
  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    final session = await repository.restoreSession();

    if (session != null) {
      state = AuthState(status: AuthStatus.authenticated, session: session);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// LOGIN
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final session = await repository.login(
      username: username,
      password: password,
    );

    state = AuthState(status: AuthStatus.authenticated, session: session);
  }

  /// REGISTER
  Future<void> register({
    required String username,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final session = await repository.register(
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    state = AuthState(status: AuthStatus.authenticated, session: session);
  }

  /// LOGOUT
  Future<void> logout() async {
    await repository.logout();

    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
