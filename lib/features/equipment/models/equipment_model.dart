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
  final String capacityUnit;
  final String? ownerComment;
  final String rentCondition;
  final String status;
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
    required this.capacityUnit,
    this.ownerComment,
    required this.rentCondition,
    required this.status,
    this.imageUrl,
    required this.isVisible,
    required this.ownerId,
    required this.locations,
    required this.prices,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      "id": id,
      "name": name,
      "model": model,
      "capacity": capacity,
      "capacityUnit": capacityUnit,
      "rentCondition": rentCondition,
      "status": status,
      "isVisible": isVisible,
      "ownerId": ownerId,
    };

    if (ownerComment != null) {
      data["ownerComment"] = ownerComment;
    }

    if (imageUrl != null) {
      data["imageUrl"] = imageUrl;
    }

    if (prices.isNotEmpty) {
      data["prices"] = prices.map((e) => e.toJson()).toList();
    }

    if (locations.isNotEmpty) {
      data["locations"] = locations.map((e) => e.toJson()).toList();
    }

    return data;
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json["id"],
      name: json["name"],
      model: json["model"],
      capacity: json["capacity"].toString(),
      capacityUnit: json["capacityUnit"].toString(),
      ownerComment: json["ownerComment"],
      rentCondition: json["rentCondition"],
      status: json["status"],
      prices: (json["prices"] as List<dynamic>? ?? [])
          .map((e) => PriceEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json["imageUrl"] as String?,
      isVisible: json["isVisible"],
      ownerId: json["ownerId"],
      locations: (json['locations'] as List<dynamic>? ?? [])
          .map((e) => EquipmentLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
