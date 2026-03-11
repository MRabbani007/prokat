sealed class AuthCredentials {}

class UsernamePasswordCredentials extends AuthCredentials {
  final String username;
  final String password;

  UsernamePasswordCredentials({required this.username, required this.password});
}

class PhoneOtpCredentials extends AuthCredentials {
  final String phone;
  final String otp;

  PhoneOtpCredentials({required this.phone, required this.otp});
}
