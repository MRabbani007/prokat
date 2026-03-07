import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_provider.dart';
import '../data/equipment_repository.dart';

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return EquipmentRepository(api);
});
