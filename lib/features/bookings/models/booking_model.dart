class BookingModel {
  final String id;
  final String status;

  final DateTime? bookedOn;
  final DateTime? bookedAt;

  final int price;
  final String priceRate;

  final String? comment;
  final String? instructions;

  final String userId;

  final String equipmentId;
  final String equipmentName;
  final String locationId;

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
    required this.userId,
    required this.equipmentId,
    required this.equipmentName,
    required this.locationId,
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

      status: json['status'], // fallback

      bookedOn: tryParseDate(json['bookedOn']),
      bookedAt: tryParseDate(json['bookedAt']),

      price: (json['price'] as num?)?.toInt() ?? 0,
      priceRate: json['priceRate']?.toString() ?? '',

      comment: json['comment'] ?? '',
      instructions: json['instructions'] ?? '',

      userId: json['userId']?.toString() ?? '',
      equipmentId: json['equipmentId']?.toString() ?? '',
      equipmentName: json['equipmentName']?.toString() ?? '',
      locationId: json['locationId']?.toString() ?? '',

      createdAt: tryParseDate(json['createdAt']),
      updatedAt: tryParseDate(json['updatedAt']),
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
      "equipmentId": equipmentId,
      "equipmentName": equipmentName,
      "locationId": locationId,
    };
  }
}
