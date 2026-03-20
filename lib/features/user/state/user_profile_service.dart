import 'package:prokat/core/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:prokat/core/constants/api_routes.dart';
import 'package:prokat/features/user/models/user_profile_model.dart';

class UserProfileService {
  final ApiClient apiClient;

  UserProfileService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<UserProfileModel?> getUserProfile() async {
    try {
      final res = await _dio.get(ApiRoutes.profile);

      return UserProfileModel.fromJson(res.data['data']);
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileModel?> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImageUrl,
    String? darkMode,
    String? selectedCategoryId,
    String? selectedAddressId,
  }) async {
    try {
      final res = await _dio.patch(
        ApiRoutes.profile,
        data: {
          if (firstName != null) "firstName": firstName,
          if (lastName != null) "lastName": lastName,
          if (phone != null) "phone": phone,
          if (profileImageUrl != null) "profileImageUrl": profileImageUrl,
          if (darkMode != null) "darkMode": darkMode,
          if (selectedCategoryId != null) "selectedCategoryId": selectedCategoryId,
          if (selectedAddressId != null) "selectedAddressId": selectedAddressId,
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserProfileModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileModel?> cancelRequest(String id) async {
    try {
      final res = await _dio.patch(
        '/requests/$id',
        data: {"status": "CANCELLED"},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserProfileModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
