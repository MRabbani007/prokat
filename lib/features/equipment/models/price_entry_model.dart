// enum PriceRate { PER_TRIP, PER_DAY, PER_HOUR, PER_CUBIC_METER }

// PriceRate priceRateFromString(String value) {
//   return PriceRate.values.firstWhere(
//     (e) => e.name == value,
//     orElse: () => PriceRate.PER_TRIP,
//   );
// }

class PriceEntry {
  final String id;
  final int price;
  final String priceRate;
  final int serviceTime;

  PriceEntry({
    required this.id,
    required this.price,
    required this.priceRate,
    required this.serviceTime,
  });

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      id: json["id"],
      price: json["price"],
      priceRate: json["priceRate"],
      serviceTime: json["serviceTime"] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "price": price,
      "priceRate": priceRate,
      "serviceTime": serviceTime,
    };
  }
}
