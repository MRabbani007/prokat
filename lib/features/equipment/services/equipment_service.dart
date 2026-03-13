import 'package:dio/dio.dart';
import '../../../core/api/base_repository.dart';
import '../../../core/constants/api_routes.dart';
import '../models/equipment_model.dart';

class EquipmentService extends BaseRepository {
  final Dio dio;

  EquipmentService(this.dio);

  Future<List<Equipment>> getEquipments() {
    return execute(() async {
      final response = await dio.get(ApiRoutes.equipment);

      final List data = response.data["data"];
      
      return data
          .map((json) => Equipment.fromJson(json))
          .where((e) => e.isVisible)
          .toList();
    });
  }
}
