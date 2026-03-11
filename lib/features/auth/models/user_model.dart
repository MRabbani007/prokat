class User {
  final String id;
  final String? username;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String role;

  const User({
    required this.id,
    this.username,
    this.phone,
    this.firstName,
    this.lastName,
    required this.role,
  });

  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return username ?? "User";
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}
