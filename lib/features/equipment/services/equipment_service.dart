import 'package:dio/dio.dart';
import '../../../core/api/base_repository.dart';
import '../../../core/constants/api_routes.dart';
import '../models/equipment_model.dart';

class EquipmentService extends BaseRepository {
  final Dio dio;

  EquipmentService(this.dio);

  Future<List<Equipment>> getEquipment() {
    return execute(() async {
      final response = await dio.get(ApiRoutes.equipment);

      final data = response.data["data"];

      if (data is! List) {
        return <Equipment>[];
      }

      final parsed = data
          .whereType<Map<String, dynamic>>() // safety check
          .map((json) => Equipment.fromJson(json))
          .where(
            (e) =>
                e.isVisible &&
                e.locations.isNotEmpty &&
                e.locations.first.latitude != null &&
                e.locations.first.longitude != null,
          )
          .toList();

      print(parsed[0].locations[0].latitude);
      print(parsed[0].locations[0].longitude);
      return parsed;
    });
  }
}
