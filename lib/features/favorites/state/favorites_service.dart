import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';

class FavoriteService {
  final ApiClient apiClient;

  FavoriteService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<({Set<String> ids, List<Equipment> equipment})> getFavorites() async {
    try {
      final res = await _dio.get('/favorites');

      // Extract both lists from your backend response
      final List favoriteIdsRaw = res.data['favoriteIds'] ?? [];
      final List equipmentRaw = res.data['equipmentList'] ?? [];

      final parsed = equipmentRaw
          .whereType<Map<String, dynamic>>()
          .map((json) => Equipment.fromJson(json))
          .toList();

      return (
        ids: favoriteIdsRaw.map((id) => id.toString()).toSet(),
        equipment: parsed, // Map this to your Equipment models later
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> toggleFavorite(String equipmentId) async {
    try {
      final res = await _dio.post(
        '/favorites/toggle',
        data: {'equipmentId': equipmentId},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
