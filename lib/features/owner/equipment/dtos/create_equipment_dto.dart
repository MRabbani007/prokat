class CreateEquipmentDto {
  final String name;
  final String model;
  final String capacity;
  final String rentCondition;
  final String? ownerComment;

  CreateEquipmentDto({
    required this.name,
    required this.model,
    required this.capacity,
    required this.rentCondition,
    this.ownerComment,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "model": model,
      "capacity": capacity,
      "rentCondition": rentCondition,
      "ownerComment": ownerComment,
    };
  }
}