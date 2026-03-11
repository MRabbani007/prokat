// features/equipment/models/equipment.dart

import 'package:prokat/features/equipment/models/equipment_location.dart';

enum EquipmentStatus { AVAILABLE, UNAVAILABLE, BOOKED }

EquipmentStatus equipmentStatusFromString(String value) {
  return EquipmentStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => EquipmentStatus.AVAILABLE,
  );
}

class Equipment {
  final String id;
  final String name;
  final String model;
  final String capacity;
  final String? ownerComment;
  final String rentCondition;
  final EquipmentStatus status;
  final bool isVisible;
  final String ownerId;

  final List<EquipmentLocation> locations;

  Equipment({
    required this.id,
    required this.name,
    required this.model,
    required this.capacity,
    this.ownerComment,
    required this.rentCondition,
    required this.status,
    required this.isVisible,
    required this.ownerId,
    required this.locations,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json["id"],
      name: json["name"],
      model: json["model"],
      capacity: json["capacity"],
      ownerComment: json["ownerComment"],
      rentCondition: json["rentCondition"],
      status: equipmentStatusFromString(json["status"]),
      isVisible: json["isVisible"],
      ownerId: json["ownerId"],

      locations: (json['locations'] as List? ?? [])
          .map((e) => EquipmentLocation.fromJson(e))
          .toList(),
    );
  }
}
