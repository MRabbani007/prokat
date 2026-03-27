import 'package:prokat/features/user/models/user_profile_model.dart';

class UserProfileState {
  final bool isLoading;
  final String? error;

  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? darkMode;

  final UserProfileModel? userProfile;

  UserProfileState({
    this.isLoading = false,
    this.error,
    this.userProfile,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.darkMode,
  });

  UserProfileState copyWith({
    bool? isLoading,
    String? error,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? darkMode,
    UserProfileModel? userProfile,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      darkMode: darkMode ?? this.darkMode,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
