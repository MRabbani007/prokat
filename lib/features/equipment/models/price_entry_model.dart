// features/equipment/models/price_entry.dart

enum PriceRate { perTrip, perDay, perHour }

PriceRate priceRateFromString(String value) {
  return PriceRate.values.firstWhere(
    (e) => e.name == value,
    orElse: () => PriceRate.perDay,
  );
}

class PriceEntry {
  final int price;
  final PriceRate rate;
  final int serviceTime;

  PriceEntry({
    required this.price,
    required this.rate,
    required this.serviceTime,
  });

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      price: json["price"],
      rate: priceRateFromString(json["priceRate"]),
      serviceTime: json["serviceTime"] ?? 0,
    );
  }
}
