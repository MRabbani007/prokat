import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';

class FavoriteService {
  final ApiClient apiClient;

  FavoriteService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<Set<String>> getFavorites() async {
    final res = await _dio.get('/favorites');
    final List data = res.data['data'];

    return data.map((e) => e['equipmentId'] as String).toSet();
  }

  Future<void> toggleFavorite(String equipmentId) async {
    await _dio.post('/favorites/toggle', data: {
      'equipmentId': equipmentId,
    });
  }
}