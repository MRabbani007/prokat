import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/api/api_client_provider.dart';
import '../services/owner_equipment_service.dart';

// Service Provider — dependency injection
// The service provider simply tells Riverpod how to create the service.
final ownerEquipmentServiceProvider = Provider<OwnerEquipmentService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return OwnerEquipmentService(apiClient);
});