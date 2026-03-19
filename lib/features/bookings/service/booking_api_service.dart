import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';

class BookingApiService {
  final ApiClient apiClient;

  BookingApiService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<List<BookingModel>> getUserBookings() async {
    try {
      final res = await _dio.get("/bookings");

      return (res.data["data"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<BookingModel>> getOwnerBookings() async {
    try {
      final res = await _dio.get("/bookings/owner");

      return (res.data["data"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
          
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<BookingModel?> createBooking(BookingModel booking) async {
    try {
      final res = await _dio.post("/bookings", data: booking.toJson());

      if (res.statusCode == 200 || res.statusCode == 201) {
        return BookingModel.fromJson(res.data["data"]);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<BookingModel?> updateBooking(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      print("updating");
      final res = await _dio.patch("/bookings/$id/status", data: data);


      if (res.statusCode == 200 || res.statusCode == 201) {
        return BookingModel.fromJson(res.data["data"]);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
