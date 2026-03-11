// features/equipment/models/equipment_location.dart

class EquipmentLocation {
  final String name;
  final double latitude;
  final double longitude;

  EquipmentLocation({required this.latitude, required this.longitude, required this.name});

  factory EquipmentLocation.fromJson(Map<String, dynamic> json) {
    return EquipmentLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json["name"]
    );
  }
}
