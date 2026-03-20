import 'package:prokat/features/auth/models/user_model.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/locations/models/location_model.dart';

class RequestModel {
  final String id;
  final String status;
  final Category? category;
  final String capacity;
  final int offeredRate;
  final String? comment;
  final DateTime? requiredOn;
  final DateTime? requiredAt;
  final User? renter;
  final LocationModel location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequestModel({
    required this.id,
    required this.capacity,
    this.requiredOn,
    this.requiredAt,
    this.comment,
    required this.offeredRate,
    required this.status,
    this.category,
    required this.location,
    this.renter,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    try {
      return RequestModel(
        id: json['id']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        capacity: json['capacity']?.toString() ?? '',
        comment: json['comment']?.toString() ?? '',

        offeredRate: json['offeredRate'] as int,

        requiredOn: DateTime.parse(json['requiredOn']),
        requiredAt: json['requiredAt'] != null
            ? DateTime.parse(json['requiredAt'])
            : null,

        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,

        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : throw Exception("Location is required but missing"),

        renter: json["renter"] != null ? User.fromJson(json["renter"]) : null,

        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,

        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );
    } catch (e) {
      print("Request Parse Failed");
      print(json);
      rethrow; // important
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "category": category?.toJson(),
      "capacity": capacity,
      "offeredRate": offeredRate,
      "comment": comment,
      "location": location.toJson(),
      "renter": renter?.toJson(),
      "requiredOn": requiredOn?.toIso8601String(),
      "requiredAt": requiredAt?.toIso8601String(),
    };
  }
}
