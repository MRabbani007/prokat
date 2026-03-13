class LocationSearchResult {
  final String name;
  final String street;
  final String? city;
  final String? country;
  final double longitude;
  final double latitude;

  LocationSearchResult({
    required this.name,
    required this.street,
    this.city,
    this.country,
    required this.longitude,
    required this.latitude,
  });
}