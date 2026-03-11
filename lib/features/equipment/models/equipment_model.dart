// features/equipment/models/equipment.dart

import 'package:prokat/features/equipment/models/equipment_location.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';

enum EquipmentStatus { available, unavailable, booked }

EquipmentStatus equipmentStatusFromString(String value) {
  return EquipmentStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => EquipmentStatus.available,
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
  final String? imageUrl;
  final List<PriceEntry> prices;

  final List<EquipmentLocation> locations;

  Equipment({
    required this.id,
    required this.name,
    required this.model,
    required this.capacity,
    this.ownerComment,
    required this.rentCondition,
    required this.status,
    required this.imageUrl,
    required this.isVisible,
    required this.ownerId,
    required this.locations,
    required this.prices,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "model": model,
      "capacity": capacity,
      "ownerComment": ownerComment,
      "rentCondition": rentCondition,
      "status": status.name,
      "imageUrl": imageUrl,
      "isVisible": isVisible,
      "ownerId": ownerId,
      // "locations": locations.map((e) => e.toJson()).toList(),
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json["id"],
      name: json["name"],
      model: json["model"],
      capacity: json["capacity"],
      ownerComment: json["ownerComment"],
      rentCondition: json["rentCondition"],
      status: equipmentStatusFromString(json["status"]),
      prices: [],
      imageUrl: json["imageUrl"],
      isVisible: json["isVisible"],
      ownerId: json["ownerId"],

      locations: (json['locations'] as List? ?? [])
          .map((e) => EquipmentLocation.fromJson(e))
          .toList(),
    );
  }
}
