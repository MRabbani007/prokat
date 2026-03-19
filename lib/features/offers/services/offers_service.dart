import 'package:prokat/core/api/api_client.dart';
import 'package:prokat/features/offers/models/offer_model.dart';
import 'package:dio/dio.dart';

class OffersService {
  final ApiClient apiClient;

  OffersService(this.apiClient);

  Dio get _dio => apiClient.dio;

  Future<List<OfferModel>> getUserOffers() async {
    try {
      final res = await _dio.get('/offers');

      return (res.data['data'] as List)
          .map((e) => OfferModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OfferModel>> getOwnerOffers() async {
    try {
      final res = await _dio.get('/offers/owner');

      return (res.data['data'] as List)
          .map((e) => OfferModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<OfferModel?> createOffer({
    required String equipmentId,
    required int price,
    required String priceRate,
    String? comment,
  }) async {
    try {
      final res = await _dio.post(
        '/offers',
        data: {
          "equipmentId": equipmentId,
          "price": price,
          "priceRate": priceRate,
          "comment": comment,
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return OfferModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<OfferModel?> updateOffer({
    required String id,
    String? locationId,
    DateTime? requiredOn,
    DateTime? requiredAt,
    int? offeredRate,
  }) async {
    try {
      final res = await _dio.patch(
        '/offers/$id',
        data: {
          if (locationId != null) "locationId": locationId,
          if (requiredOn != null) "requiredOn": requiredOn.toIso8601String(),
          if (requiredAt != null) "requiredAt": requiredAt.toIso8601String(),
          if (offeredRate != null) "offeredRate": offeredRate,
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return OfferModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<OfferModel?> cancelOffer(String id) async {
    try {
      final res = await _dio.patch(
        '/offers/$id',
        data: {"status": "CANCELLED"},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return OfferModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
