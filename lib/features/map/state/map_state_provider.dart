import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';

// class MapState {
//   Equipment? selectedEquipment;
//   LatLng? selectedLocation;
//   bool isPlacingPin;
//   bool isSheetExpanded;
// }

class EquipmentMapState {
  final Equipment? selectedEquipment;
  final bool isSheetExpanded;

  const EquipmentMapState({
    this.selectedEquipment,
    this.isSheetExpanded = false,
  });

  EquipmentMapState copyWith({
    Equipment? selectedEquipment,
    bool? isSheetExpanded,
    bool clearSelection = false, // 👈 add this
  }) {
    return EquipmentMapState(
      selectedEquipment:
          clearSelection ? null : selectedEquipment ?? this.selectedEquipment,
      isSheetExpanded: isSheetExpanded ?? this.isSheetExpanded,
    );
  }
}

class EquipmentMapController extends StateNotifier<EquipmentMapState> {
  EquipmentMapController() : super(const EquipmentMapState());

  void selectEquipment(Equipment equipment) {
    state = state.copyWith(
      selectedEquipment: equipment,
      isSheetExpanded: true, // 👈 auto open drawer
    );
  }

  void clearSelection() {
    state = state.copyWith(
      clearSelection: true,
      isSheetExpanded: false,
    );
  }

  void toggleSheet(bool expanded) {
    state = state.copyWith(isSheetExpanded: expanded);
  }
}