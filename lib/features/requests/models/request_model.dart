enum RequestStatus { CREATED, CANCELLED, FULFILLED }

class RequestModel {
  final String id;
  final String capacity;
  final DateTime requiredOn;
  final DateTime? requiredAt;
  final String? comment;
  final int offeredRate;
  final String status;
  final String? categoryId;
  final String locationId;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequestModel({
    required this.id,
    required this.capacity,
    required this.requiredOn,
    this.requiredAt,
    this.comment,
    required this.offeredRate,
    required this.status,
    this.categoryId,
    required this.locationId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      capacity: json['capacity'] as String,
      requiredOn: DateTime.parse(json['requiredOn']),
      requiredAt: json['requiredAt'] != null
          ? DateTime.parse(json['requiredAt'])
          : null,
      comment: json['comment'] as String?,

      offeredRate: json['offeredRate'] as int,

      /// 🔥 SAFE status parsing
      status: json['status'] as String,

      /// 🔥 FIX: nullable
      categoryId: json['categoryId'] as String?,

      locationId: json['locationId'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
