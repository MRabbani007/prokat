import 'package:prokat/features/user/models/user_profile_model.dart';

class UserProfileState {
  final bool isLoading;
  final String? error;

  final String? firstName;
  final String? lastName;
  final String? darkMode;

  final UserProfileModel? userProfile;

  UserProfileState({
    this.isLoading = false,
    this.error,
    this.userProfile,
    this.firstName,
    this.lastName,
    this.darkMode,
  });

  UserProfileState copyWith({
    bool? isLoading,
    String? error,
    String? firstName,
    String? lastName,
    String? darkMode,
    UserProfileModel? userProfile,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      darkMode: darkMode ?? this.darkMode,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
