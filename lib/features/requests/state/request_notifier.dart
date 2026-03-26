import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/locations/models/location_model.dart';
import 'package:prokat/features/requests/services/request_service.dart';
import 'package:prokat/features/requests/state/request_state.dart';

class RequestNotifier extends StateNotifier<RequestState> {
  final RequestService service; 

  RequestNotifier(this.service) : super(RequestState()) {
    getUserRequests();
  }

  void selectLocation(LocationModel location) {
    state = state.copyWith(
      selectedLocationId: location.id,
      selectedLocation: location,
    );
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTime(DateTime time) {
    state = state.copyWith(selectedTime: time);
  }

  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void setOfferedRate(int? offeredRate) {
    state = state.copyWith(offeredRate: offeredRate);
  }

  void setCapacity(String? capacity) {
    state = state.copyWith(capacity: capacity);
  }

  Future<void> getUserRequests() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getUserRequests();

      state = state.copyWith(isLoading: false, requests: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        requests: [],
        error: e.toString(),
      );
    }
  }

  Future<void> getOwnerRequests() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getOwnerRequests();

      state = state.copyWith(isLoading: false, requests: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        requests: [],
        error: e.toString(),
      );
    }
  }

  Future<bool> createRequest() async {
    try {
      // if (state.selectedLocation?.id == null ||
      //     state.selectedDate == null ||
      //     state.selectedTime == null) {
      //   return false;
      // }

      state = state.copyWith(isLoading: true);

      final created = await service.createRequest(
        categoryId: state.categoryId ?? "",
        locationId: state.selectedLocation?.id ?? "",
        capacity: state.capacity ?? "",
        requiredOn: state.selectedDate ?? DateTime(2026),
        requiredAt: state.selectedTime,
        comment: state.comment,
        offeredRate: state.offeredRate ?? 0,
      );

      if (created != null) {
        state = state.copyWith(
          isLoading: false,
          requests: [...state.requests, created],
        );

        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        requests: state.requests,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> updateRequest({
    required String id,
    String? locationId,
    DateTime? requiredOn,
    DateTime? requiredAt,
    int? offeredRate,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final updated = await service.updateRequest(
        id: id,
        locationId: locationId,
        requiredOn: requiredOn,
        requiredAt: requiredAt,
        offeredRate: offeredRate,
      );

      if (updated != null) {
        await getUserRequests();
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> cancelRequest(String id) async {
    await service.cancelRequest(id);
    await getUserRequests();
  }
}
