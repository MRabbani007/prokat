import 'package:prokat/core/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:prokat/core/constants/api_routes.dart';
import 'package:prokat/features/user/models/user_profile_model.dart';
import 'dart:io';

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
    String? phoneNumber,
    String? phoneCountryCode,
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
          if (phoneNumber != null) "phoneNumber": phoneNumber,
          if (phoneCountryCode != null) "phoneCountryCode": phoneCountryCode,
          if (profileImageUrl != null) "profileImageUrl": profileImageUrl,
          if (darkMode != null) "darkMode": darkMode,
          if (selectedCategoryId != null)
            "selectedCategoryId": selectedCategoryId,
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

  Future<UserProfileModel?> updateUserName(String? username) async {
    try {
      final res = await _dio.patch(
        ApiRoutes.username,
        data: {if (username != null) "username": username},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserProfileModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileModel?> selectCategory(String? selectedCategoryId) async {
    try {
      final res = await _dio.patch(
        ApiRoutes.userCategory,
        data: {
          if (selectedCategoryId != null)
            "selectedCategoryId": selectedCategoryId,
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

  Future<UserProfileModel?> selectAddress(String? addressId) async {
    try {
      final res = await _dio.patch(
        ApiRoutes.userCategory,
        data: {if (addressId != null) "addressId": addressId},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserProfileModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileModel?> selectCityRegion(
    String? city,
    String? region,
  ) async {
    try {
      final res = await _dio.patch(
        ApiRoutes.userCityRegion,
        data: {
          if (city != null) "city": city,
          if (region != null) "region": region,
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

  Future<bool> uploadProfileImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        // "profileImage" must match the key expected by your Node.js Multer setup
        "profileImage": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        // Optional: you can add other fields here
        "type": "avatar",
      });

      print("image service");

      // 2. Send the POST request
      final res = await _dio.post(
        ApiRoutes.userProfileImage, // Ensure this points to your upload route
        data: formData,
        // Optional: Track upload progress
        onSendProgress: (sent, total) {
          print("Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%");
        },
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
