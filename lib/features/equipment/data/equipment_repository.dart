import 'package:prokat/features/equipment/data/dto/equipment_dto.dart';
import 'package:prokat/features/equipment/domain/equipment.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/base_repository.dart';

class EquipmentRepository extends BaseRepository {
  final ApiClient api;

  EquipmentRepository(this.api);

  Future<ApiResponse<List<Equipment>>> getEquipment() {
    return handleRequest(() => api.dio.get("/equipment"), (data) {
      final list = data as List;

      return list.map((e) => EquipmentDto.fromJson(e).toDomain()).toList();
    });
  }
}
