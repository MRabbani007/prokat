// features/equipment/models/equipment_location.dart

class EquipmentLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  EquipmentLocation({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.name,
    required this.address,
  });

  factory EquipmentLocation.fromJson(Map<String, dynamic> json) {
    return EquipmentLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json["name"],
      id: json["id"],
      address: json["address"],
    );
  }
}
