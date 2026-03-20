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

  Future<void> getUserProfile() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getUserProfile();

      state = state.copyWith(isLoading: false, userProfile: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        userProfile: null,
        error: e.toString(),
      );
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
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
        phone: phone,
        profileImageUrl: profileImageUrl,
        darkMode: darkMode,
        selectedCategoryId: selectedCategoryId,
        selectedAddressId: selectedAddressId,
      );

      if (updated != null) {
        await getUserProfile();
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
