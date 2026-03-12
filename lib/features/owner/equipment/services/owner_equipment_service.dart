import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';
import 'package:prokat/core/constants/api_routes.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';

// Service — talks to the backend
// The service is responsible only for API communication.
// calls the backend
// sends requests
// parses responses
// returns models

class OwnerEquipmentService {
  final ApiClient apiClient;

  OwnerEquipmentService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<List<Equipment>> getOwnerEquipment() async {
    try {
      final response = await _dio.get(ApiRoutes.equipment);

      final List data = response.data["data"];

      return data.map((e) => Equipment.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to load equipment');
    }
  }

  Future<Equipment> createEquipment(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiRoutes.equipment, data: data);

      return Equipment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to create equipment');
    }
  }

  Future<Equipment> updateEquipment(
    String equipmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/equipment/$equipmentId', data: data);

      return Equipment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to update equipment');
    }
  }

  Future<Equipment> updateVisibilityStatus(
    String equipmentId,
    bool isVisible,
    String status,
  ) async {
    try {
      final response = await _dio.patch(
        '/equipment/$equipmentId/status',
        data: {"id": equipmentId, "isVisible": isVisible, "status": status},
      );

      return Equipment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to update equipment');
    }
  }

  Future<void> deleteEquipment(String equipmentId) async {
    try {
      await _dio.delete('/equipment/$equipmentId');
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to delete equipment');
    }
  }

  Future<void> addPriceEntry(
    String equipmentId,
    Map<String, dynamic> data,
  ) async {
    await _dio.post("/equipment/$equipmentId/priceEntry", data: data);
  }

  Future<void> updatePriceEntry(
    String equipmentId,
    Map<String, dynamic> data,
  ) async {
    final priceEntryId = data["id"];

    await _dio.patch(
      '/equipment/$equipmentId/priceEntry/$priceEntryId',
      data: data,
    );
  }

  Future<void> deletePriceEntry(String equipmentId, String priceEntryId) async {
    try {
      await _dio.delete('/equipment/$equipmentId/priceEntry/$priceEntryId');
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Failed to delete price entry');
    }
  }
}
