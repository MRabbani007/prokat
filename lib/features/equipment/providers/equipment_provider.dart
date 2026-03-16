import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/providers/api_provider.dart';
import '../models/equipment_model.dart';
import '../services/equipment_service.dart';

final equipmentServiceProvider = Provider<EquipmentService>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return EquipmentService(dio);
});

final equipmentProvider = FutureProvider<List<Equipment>>((ref) async {
  final service = ref.watch(equipmentServiceProvider);

  try {
    return await service.getEquipment();
  } catch (e) {
    return [];
  }
});