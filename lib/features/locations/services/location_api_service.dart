import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';
import '../models/location_model.dart';
import '../models/location_search_result.dart';

class LocationApiService {
  final ApiClient apiClient;

  LocationApiService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<List<LocationModel>> getLocations() async {
    final response = await _dio.get('/locations');

    return (response.data as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }

  Future<LocationModel> createLocation(LocationModel location) async {
    final response = await _dio.post('/locations', data: location.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LocationModel.fromJson(response.data["data"]);
    }

    throw Exception("Location creation failed (${response.statusCode})");
  }

  Future<LocationModel> updateLocation(
    String id,
    LocationModel location,
  ) async {
    final response = await _dio.patch(
      '/locations/$id',
      data: location.toJson(),
    );

    return LocationModel.fromJson(response.data);
  }

  Future<void> deleteLocation(String id) async {
    await _dio.delete('/locations/$id');
  }

  /// Search address (Mapbox or backend proxy)
  Future<List<LocationSearchResult>> searchLocation(String query) async {
    final response = await _dio.get(
      '/locations/search',
      queryParameters: {"query": query},
    );

    return (response.data as List).map((e) {
      return LocationSearchResult(
        name: e['name'] ?? '',
        street: e['street'] ?? '',
        city: e['city'],
        country: e['country'],
        longitude: (e['longitude'] as num).toDouble(),
        latitude: (e['latitude'] as num).toDouble(),
      );
    }).toList();
  }

  /// Reverse geocode coordinates → address
  Future<LocationSearchResult?> reverseGeocode(
    double longitude,
    double latitude,
  ) async {
    try {
      final response = await _dio.get(
        '/locations/reverse',
        queryParameters: {"longitude": longitude, "latitude": latitude},
      );

      if (response.statusCode != 200) {
        return null;
      }

      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        return null;
      }

      final data = response.data;

      return LocationSearchResult(
        name: data['name'],
        street: data['street'],
        city: data['city'],
        country: data['country'],
        longitude: longitude,
        latitude: latitude,
      );
    } catch (e) {
      return null;
    }
  }
}
