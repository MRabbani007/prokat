// Placeholder for your data model - replace with your actual model
class EquipmentModel {
  final String id;
  final String name;
  final String model;
  final int capacity; // e.g., "20 Ton Capacity"
  final double price; // e.g., "$350/day"
  final double latitude;
  final double longitude;
  final String location;
  final String owner;
  final String imageUrl;
  final bool available;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.model,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.owner,
    required this.capacity,
    required this.imageUrl,
    required this.available,
  });
}
