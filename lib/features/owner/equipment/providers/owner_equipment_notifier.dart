import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/owner/equipment/services/owner_equipment_service.dart';
import 'package:prokat/features/owner/equipment/services/owner_equipment_state.dart';

// Notifier — business logic + state
// stores state, calls services, updates UI state, exposes actions
class OwnerEquipmentNotifier extends StateNotifier<OwnerEquipmentState> {
  final OwnerEquipmentService service;

  OwnerEquipmentNotifier(this.service) : super(OwnerEquipmentState());

  Future<void> loadEquipment() async {
    state = state.copyWith(isLoading: true);

    try {
      final equipment = await service.getOwnerEquipment();

      state = state.copyWith(
        equipment: equipment,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

Future<void> createEquipment(Map<String, dynamic> data) async {
  await service.createEquipment(data);
  await loadEquipment();
}

Future<void> updateEquipment(String id, Map<String, dynamic> data) async {
  await service.updateEquipment(id, data);
  await loadEquipment();
}

  Future<void> deleteEquipment(String id) async {
    await service.deleteEquipment(id);

    await loadEquipment();
  }
}