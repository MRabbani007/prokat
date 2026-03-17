import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/owner/equipment/services/owner_equipment_service.dart';
import 'package:prokat/features/owner/equipment/services/owner_equipment_state.dart';

// Notifier — business logic + state
// stores state, calls services, updates UI state, exposes actions
class OwnerEquipmentNotifier extends StateNotifier<OwnerEquipmentState> {
  final OwnerEquipmentService service; 

  OwnerEquipmentNotifier(this.service) : super(OwnerEquipmentState());

  /// LOAD OWNER EQUIPMENT
  Future<void> loadEquipment() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final equipment = await service.getOwnerEquipment();

      state = state.copyWith(equipment: equipment, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Equipment? getById(String id) {
    try {
      return state.equipment.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// CREATE
  Future<void> createEquipment(Map<String, dynamic> data) async {
    try {
      final newEquipment = await service.createEquipment(data);

      state = state.copyWith(equipment: [...state.equipment, newEquipment]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// UPDATE
  Future<void> updateEquipment(String id, Map<String, dynamic> data) async {
    try {
      final updated = await service.updateEquipment(id, data);

      final updatedList = state.equipment.map((e) {
        if (e.id == id) {
          return updated;
        }
        return e;
      }).toList();

      state = state.copyWith(equipment: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateVisibilityStatus(
    String equipmentId,
    bool isVisible,
    String status,
  ) async {
    try {
      final updated = await service.updateVisibilityStatus(
        equipmentId,
        isVisible,
        status,
      );

      final updatedList = state.equipment.map((e) {
        if (e.id == equipmentId) {
          return updated;
        }
        return e;
      }).toList();

      state = state.copyWith(equipment: updatedList);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE
  Future<void> deleteEquipment(String id) async {
    try {
      await service.deleteEquipment(id);

      final updatedList = state.equipment.where((e) => e.id != id).toList();

      state = state.copyWith(equipment: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createPriceEntry(
    String equipmentId,
    int price,
    String priceRate,
    int serviceTime,
  ) async {
    try {
      await service.addPriceEntry(equipmentId, {
        "equipmentId": equipmentId,
        "price": price,
        "priceRate": priceRate,
        "serviceTime": serviceTime,
      });

      await loadEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updatePriceEntry(
    String equipmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await service.updatePriceEntry(equipmentId, data);
      await loadEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deletePriceEntry(String equipmentId, String priceEntryId) async {
    try {
      await service.deletePriceEntry(equipmentId, priceEntryId);

      // reload equipment to refresh price entries
      await loadEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
