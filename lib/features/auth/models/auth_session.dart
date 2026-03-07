import 'package:prokat/features/auth/models/user_model.dart';

class AuthSession {
  final String sessionToken;
  final DateTime? expires;
  final User user;

  const AuthSession({
    required this.sessionToken,
    required this.user,
    this.expires,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      sessionToken: json['sessionToken'],
      expires: json['expires'] != null ? DateTime.parse(json['expires']) : null,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionToken': sessionToken,
      'expires': expires?.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
