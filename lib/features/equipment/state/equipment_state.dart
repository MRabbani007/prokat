import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/locations/models/location_model.dart';

class EquipmentState {
  final bool isLoading;
  final String? error;

  final List<Equipment> ownerEquipment;
  final List<Equipment> renterEquipment;

  // Renter selected equipment for booking
  final Equipment? equipment;

  final Equipment? editEquipment;

  final Category? category;
  final LocationModel? location;

  EquipmentState({
    this.isLoading = false,
    this.error,
    this.ownerEquipment = const [],
    this.renterEquipment = const [],
    this.equipment,
    this.editEquipment,
    this.category,
    this.location,
  });

  EquipmentState copyWith({
    final bool? isLoading,
    final String? error,
    List<Equipment>? ownerEquipment,
    List<Equipment>? renterEquipment,
    Category? category,
    Equipment? editEquipment,
  }) {
    return EquipmentState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      ownerEquipment: ownerEquipment ?? this.ownerEquipment,
      renterEquipment: renterEquipment ?? this.renterEquipment,
      category: category ?? this.category,
      editEquipment: editEquipment ?? this.editEquipment,
    );
  }
}
