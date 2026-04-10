import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/state/equipment_service.dart';
import 'package:prokat/features/equipment/state/equipment_state.dart';

class EquipmentNotifier extends StateNotifier<EquipmentState> {
  final EquipmentService api;

  EquipmentNotifier(this.api) : super(EquipmentState());

  void selectCategory(Category category) {
    state = state.copyWith(category: category);
  }

  void selectEditEquipment(Equipment equipment) {
    state = state.copyWith(editEquipment: equipment);
  }

  Future<void> getOwnerEquipment() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final equipment = await api.getOwnerEquipment();

      state = state.copyWith(ownerEquipment: equipment, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getRenterEquipment() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final equipment = await api.getRenterEquipment();

      print(equipment.toString());
      state = state.copyWith(renterEquipment: equipment, isLoading: false);
    } catch (e) {
      print(e.toString());
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Equipment? getById(String id) {
    try {
      return state.ownerEquipment.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// CREATE
  Future<bool> createEquipment(Map<String, dynamic> data) async {
    try {
      final newEquipment = await api.createEquipment(data);

      state = state.copyWith(
        ownerEquipment: [...state.ownerEquipment, newEquipment],
      );

      await getOwnerEquipment();

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  /// UPDATE
  Future<bool> updateEquipment(String id, Map<String, dynamic> data) async {
    try {
      final updated = await api.updateEquipment(id, data);

      final updatedList = state.ownerEquipment.map((e) {
        if (e.id == id) {
          return updated;
        }
        return e;
      }).toList();

      state = state.copyWith(ownerEquipment: updatedList);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  Future<bool> updateEquipmentLocation(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final updated = await api.updateEquipmentLocation(id, data);

      final updatedList = state.ownerEquipment.map((e) {
        if (e.id == id) {
          return updated;
        }
        return e;
      }).toList();

      state = state.copyWith(
        ownerEquipment: updatedList,
        editEquipment: updated,
      );

      return true;
    } catch (e) {
      print(e);
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateVisibilityStatus(
    String equipmentId,
    bool isVisible,
    String status,
  ) async {
    try {
      await api.updateVisibilityStatus(equipmentId, isVisible, status);

      await getOwnerEquipment();

      // final updatedList = state.ownerEquipment.map((e) {
      //   if (e.id == equipmentId) {
      //     return updated;
      //   }

      //   return e;
      // }).toList();

      // state = state.copyWith(ownerEquipment: updatedList);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// DELETE
  Future<void> deleteEquipment(String id) async {
    try {
      await api.deleteEquipment(id);

      final updatedList = state.ownerEquipment
          .where((e) => e.id != id)
          .toList();

      state = state.copyWith(ownerEquipment: updatedList);
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
      await api.addPriceEntry(equipmentId, {
        "equipmentId": equipmentId,
        "price": price,
        "priceRate": priceRate,
        "serviceTime": serviceTime,
      });

      await getOwnerEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updatePriceEntry(
    String equipmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await api.updatePriceEntry(equipmentId, data);
      await getOwnerEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deletePriceEntry(String equipmentId, String priceEntryId) async {
    try {
      await api.deletePriceEntry(equipmentId, priceEntryId);

      // reload equipment to refresh price entries
      await getOwnerEquipment();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
