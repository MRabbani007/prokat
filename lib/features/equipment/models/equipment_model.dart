import 'package:prokat/features/auth/models/user_model.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/equipment/models/equipment_location.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';

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
  final User? owner;
  final String? imageUrl;
  final List<PriceEntry> prices;
  final EquipmentLocation? location;
  final String? categoryId;
  final Category? category;

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
    this.owner,
    this.categoryId,
    this.category,
    this.location,
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
      "owner": owner,
      "category": category,
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

    if (location != null) {
      data["location"] = location;
    }

    return data;
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    try {
      return Equipment(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        model: json["model"] ?? '',

        capacity: json["capacity"].toString(),
        capacityUnit: json["capacityUnit"]?.toString() ?? '',

        ownerComment: json["ownerComment"],
        rentCondition: json["rentCondition"],

        status: json["status"],

        prices: (json["prices"] as List<dynamic>? ?? [])
            .map((e) => PriceEntry.fromJson(e as Map<String, dynamic>))
            .toList(),

        imageUrl: json["imageUrl"] as String?,

        isVisible: json["isVisible"],

        owner: json["owner"] != null ? User.fromJson(json["owner"]) : null,

        location: json['location'] != null
            ? EquipmentLocation.fromJson(json['location'])
            : null,

        categoryId: json["categoryId"] != null
            ? json["categoryId"].toString()
            : null,
        category: json["category"] != null
            ? Category.fromJson(json["category"])
            : null,
      );
    } catch (e, stack) {
      print("❌ Equipment parsing failed");
      print("JSON: $json");
      print(e);
      print(stack);
      rethrow; // important
    }
  }
}
