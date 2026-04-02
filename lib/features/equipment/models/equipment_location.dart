class EquipmentLocation {
  final String id;
  final String street;
  final String? city;
  final double? longitude;
  final double? latitude;

  EquipmentLocation({
    required this.id,
    required this.street,
    this.longitude,
    this.latitude,
    this.city,
  });

  factory EquipmentLocation.fromJson(Map<String, dynamic> json) {
    return EquipmentLocation(
      id: json["id"],
      street: json["street"],
      city: json["city"],
      longitude: double.tryParse(json["longitude"].toString()) ?? 0,
      latitude: double.tryParse(json["latitude"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "street": street,
      "city": city,
      "longitude": longitude,
      "latitude": latitude,
    };
  }
}
