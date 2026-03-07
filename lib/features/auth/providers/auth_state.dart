import 'package:prokat/features/auth/models/auth_session.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final AuthSession? session;

  const AuthState({required this.status, this.session});

  AuthState copyWith({AuthStatus? status, AuthSession? session}) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
    );
  }
}
