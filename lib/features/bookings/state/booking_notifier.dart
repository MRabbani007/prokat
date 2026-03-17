import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';
import 'package:prokat/features/bookings/service/booking_api_service.dart';
import 'package:prokat/features/bookings/state/booking_state.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/features/locations/models/location_model.dart';

class BookingNotifier extends StateNotifier<BookingState> {
  final BookingApiService api;

  BookingNotifier(this.api) : super(BookingState());

  /// -------------------------
  /// LOCAL DRAFT MANAGEMENT
  /// -------------------------

  void selectEquipment(Equipment equipment) {
    state = state.copyWith(selectedEquipment: equipment);
  }

  void selectPriceEntry(PriceEntry priceEntry) {
    state = state.copyWith(selectedPriceEntry: priceEntry);
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

  void startBooking(Equipment equipment) {
    state = BookingState(selectedEquipment: equipment);
  }

  /// -------------------------
  /// CREATE BOOKING
  /// -------------------------

  Future<bool> createBooking() async {
    try {
      state = state.copyWith(isLoading: true);

      final booking = BookingModel(
        id: "",
        status: "CREATED",
        equipmentName:"",
        bookedOn: state.selectedDate!,
        bookedAt: state.selectedTime!,
        price:
            state.selectedPriceEntry?.price ??
            0, // backend should calculate later
        priceRate: state.selectedPriceEntry?.priceRate ?? "",
        comment: state.comment,
        instructions: null,
        userId: "",
        equipmentId: state.selectedEquipment?.id ?? "",
        locationId: state.selectedLocation?.id ?? "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await api.createBooking(booking);

      if (created != null) {
        state = state.copyWith(
          isLoading: false,
          currentBooking: created,
          bookings: [...state.bookings, created],
        );

        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// -------------------------
  /// LOAD BOOKINGS
  /// -------------------------

  Future<void> getBookings() async {
    try {
      state = state.copyWith(isLoading: true);

      final bookings = await api.getBookings();

      state = state.copyWith(isLoading: false, bookings: bookings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// -------------------------
  /// UPDATE BOOKING
  /// -------------------------

  Future<void> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      final updated = await api.updateBooking(id, data);

      final updatedList = state.bookings.map((b) {
        return b.id == id ? updated : b;
      }).toList();

      state = state.copyWith(
        bookings: updatedList,
        currentBooking: state.currentBooking?.id == id
            ? updated
            : state.currentBooking,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
