class UserProfileModel {
  final String? username;
  final String? phoneNumber;
  final bool? isPhoneVerified;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;
  final String? role;
  final String? darkMode;
  final String? selectedCategoryId;
  final String? selectedAddressId;

  UserProfileModel({
    this.username,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.isPhoneVerified,
    this.role,
    this.profileImageUrl,
    this.darkMode,
    this.selectedCategoryId,
    this.selectedAddressId,
  });

  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return username ?? "User";
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfileModel(
        username: json['username']?.toString(),
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        isPhoneVerified: json['isPhoneVerified'],
        role: json['role']?.toString(),
        profileImageUrl: json['profileImageUrl']?.toString(),
        darkMode: json['darkMode']?.toString(),
        selectedCategoryId: json['selectedCategoryId']?.toString(),
        selectedAddressId: json['selectedAddressId']?.toString(),
      );
    } catch (e, stack) {
      print("❌ User Profile parsing failed");
      print("JSON: $json");
      print(e);
      print(stack);
      rethrow; // important
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'isPhoneVerified': isPhoneVerified,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'darkMode': darkMode,
      'selectedCategoryId': selectedCategoryId,
      'selectedAddressId': selectedAddressId,
    };
  }
}
