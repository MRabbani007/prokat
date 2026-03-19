import 'package:prokat/features/bookings/models/booking_model.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/requests/models/request_model.dart';

class OfferModel {
  final String id;
  final String status;
  final RequestModel? request;
  final Equipment? equipment;
  final int price;
  final String priceRate;
  final BookingModel? booking;

  OfferModel({
    required this.id,
    required this.status,
    required this.request,
    required this.equipment,
    required this.price,
    required this.priceRate,
    this.booking,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    try {
      return OfferModel(
        id: json['id']?.toString() ?? '',
        status: json['status']?.toString() ?? '',

        request: json['request'] != null
            ? RequestModel.fromJson(json['request'])
            : null,
        equipment: json['equipment'] != null
            ? Equipment.fromJson(json['equipment'])
            : null,
        booking: json['booking'] != null
            ? BookingModel.fromJson(json['booking'])
            : null,

        price: json['price'] as int,
        priceRate: json['priceRate']?.toString() ?? '',
      );
    } catch (e) {
      print("Offer Parse Failed");
      print(json);
      rethrow; // importan
    }
  }

    Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "price": price,
      "priceRate": priceRate,
      "request": request?.toJson(),
      "equipment": equipment?.toJson(),
      "booking": booking?.toJson(),
    };
  }
}
