import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/user/state/user_profile_service.dart';
import 'package:prokat/features/user/state/user_profile_state.dart';

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserProfileService service;

  UserProfileNotifier(this.service) : super(UserProfileState()) {
    getUserProfile();
  }

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setDarkMode(String darkMode) {
    state = state.copyWith(darkMode: darkMode);
  }

  Future<bool> getUserProfile() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getUserProfile();

      if (data == null) {
        return false;
      }

      state = state.copyWith(isLoading: false, userProfile: data);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        userProfile: null,
        error: e.toString(),
      );

      return false;
    }
  }

  Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? phoneCountryCode,
    String? profileImageUrl,
    String? darkMode,
    String? selectedCategoryId,
    String? selectedAddressId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final updated = await service.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        darkMode: darkMode,
        selectedCategoryId: selectedCategoryId,
        selectedAddressId: selectedAddressId,
      );

      if (updated != null) {
        await getUserProfile();

        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateUserName(String username) async {
    try {
      state = state.copyWith(isLoading: true);

      final updated = await service.updateUserName(username);

      if (updated != null) {
        await getUserProfile();

        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
