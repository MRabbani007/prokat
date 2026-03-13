import '../models/location_model.dart';
import '../models/location_search_result.dart';

class LocationState {
  final List<LocationModel> locations;
  final List<LocationSearchResult> suggestions;

  final bool isLoading;
  final String? error;

  const LocationState({
    this.locations = const [],
    this.suggestions = const [],
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    List<LocationModel>? locations,
    List<LocationSearchResult>? suggestions,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      locations: locations ?? this.locations,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}