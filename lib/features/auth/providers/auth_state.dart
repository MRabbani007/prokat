

import 'package:prokat/features/auth/models/auth_session.dart';

class AuthState {
  final AuthSession? session;
  final bool isLoading;
  final String? error;

  const AuthState({this.session, this.isLoading = false, this.error});

  bool get isAuthenticated => session != null;

  AuthState copyWith({AuthSession? session, bool? isLoading, String? error}) {
    return AuthState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
