import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/locations/models/location_search_result.dart';
import '../models/location_model.dart';
import '../services/location_api_service.dart';
import 'location_state.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  final LocationApiService api;

  LocationNotifier(this.api) : super(const LocationState());

  List<LocationSearchResult> suggestions = [];

  /// Fetch user locations
  Future<void> loadLocations() async {
    try {
      state = state.copyWith(isLoading: true);

      final locations = await api.getLocations();

      state = state.copyWith(locations: locations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create new location
  Future<bool> createLocation(LocationModel location) async {
    try {
      final newLocation = await api.createLocation(location);

      state = state.copyWith(locations: [...state.locations, newLocation]);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update location
  Future<void> updateLocation(String id, LocationModel location) async {
    try {
      final updated = await api.updateLocation(id, location);

      final updatedList = state.locations.map((l) {
        if (l.id == id) return updated;
        return l;
      }).toList();

      state = state.copyWith(locations: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete location
  Future<void> deleteLocation(String id) async {
    try {
      await api.deleteLocation(id);

      state = state.copyWith(
        locations: state.locations.where((l) => l.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }

    try {
      final results = await api.searchLocation(query);

      print("locationnotifier");
      for (final r in results) {
        print("${r.street}, ${r.city}, ${r.country}");
      }

      state = state.copyWith(suggestions: results);

      print("state suggestions length: ${state.suggestions.length}");
    } catch (e) {
      print(e.toString());
      state = state.copyWith(error: e.toString());
    }
  }

  void clearSuggestions() {
    state = state.copyWith(suggestions: []);
  }
}
