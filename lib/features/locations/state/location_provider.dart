import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/api/api_client_provider.dart';
import '../services/location_api_service.dart';
import 'location_notifier.dart';
import 'location_state.dart';

final locationApiProvider = Provider<LocationApiService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LocationApiService(apiClient);
});

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  final api = ref.read(locationApiProvider);
  return LocationNotifier(api);
}); 