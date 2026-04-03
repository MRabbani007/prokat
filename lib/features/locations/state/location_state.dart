import '../models/location_model.dart';
import '../models/location_search_result.dart';

class LocationState {
  final String? city;

  final List<LocationModel> renterLocations;
  final List<LocationModel> ownerLocations;

  final LocationModel? selectedAddress;

  final List<LocationSearchResult> suggestions;

  final bool isLoading;
  final String? error;

  const LocationState({
    this.city,

    this.renterLocations = const [],
    this.ownerLocations = const [],

    this.selectedAddress,

    this.suggestions = const [],

    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    String? city,

    List<LocationModel>? renterLocations,
    List<LocationModel>? ownerLocations,

    List<LocationSearchResult>? suggestions,

    LocationModel? selectedAddress,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      city: city ?? this.city,
      renterLocations: renterLocations ?? this.renterLocations,
      ownerLocations: ownerLocations ?? this.ownerLocations,

      suggestions: suggestions ?? this.suggestions,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
