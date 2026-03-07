class AuthUser {
  final String id;
  final String phone;

  AuthUser({required this.id, required this.phone});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(id: json['id'], phone: json['phone']);
  }
}
