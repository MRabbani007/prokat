import 'package:prokat/features/equipment/models/equipment_model.dart';

class OwnerEquipmentState {
  final List<Equipment> equipment;
  final bool isLoading;
  final String? error;

  OwnerEquipmentState({
    this.equipment = const [],
    this.isLoading = false,
    this.error,
  });

  OwnerEquipmentState copyWith({
    List<Equipment>? equipment,
    bool? isLoading,
    String? error,
  }) {
    return OwnerEquipmentState(
      equipment: equipment ?? this.equipment,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}