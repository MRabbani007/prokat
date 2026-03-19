import 'package:prokat/features/auth/models/user_model.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/locations/models/location_model.dart';

class BookingModel {
  final String id;
  final String status;

  final DateTime? bookedOn;
  final DateTime? bookedAt;

  final int price;
  final String priceRate;

  final String? comment;
  final String? instructions;

  final User? renter;

  final Equipment equipment;
  final LocationModel location;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookingModel({
    required this.id,
    required this.status,
    this.bookedOn,
    this.bookedAt,
    required this.price,
    required this.priceRate,
    this.comment,
    this.instructions,
    this.renter,
    required this.equipment,
    required this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    DateTime? tryParseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }

    return BookingModel(
      id: json['id']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      bookedOn: tryParseDate(json['bookedOn']),
      bookedAt: tryParseDate(json['bookedAt']),

      price: (json['price'] as num?)?.toInt() ?? 0,
      priceRate: json['priceRate']?.toString() ?? '',

      comment: json['comment']?.toString(),
      instructions: json['instructions']?.toString(),

      renter: json['renter'] != null ? User.fromJson(json['renter']) : null,

      equipment: json['equipment'] != null
          ? Equipment.fromJson(json['equipment'])
          : throw Exception("Equipment is required but missing"),

      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : throw Exception("Location is required but missing"),

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "bookedOn": bookedOn?.toIso8601String(),
      "bookedAt": bookedAt?.toIso8601String(),
      "price": price,
      "priceRate": priceRate,
      "comment": comment,
      "instructions": instructions,
      "equipment": equipment.toJson(),
      "location": location.toJson(),
      "renter": renter?.toJson(),
    };
  }
}
