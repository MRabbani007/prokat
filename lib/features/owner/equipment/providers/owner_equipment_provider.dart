import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_notifier.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_service_provider.dart';
import 'package:prokat/features/owner/equipment/services/owner_equipment_state.dart';

// Owner Equipment Provider — exposes the notifier
final ownerEquipmentProvider =
    StateNotifierProvider<OwnerEquipmentNotifier, OwnerEquipmentState>((ref) {
  final service = ref.read(ownerEquipmentServiceProvider);
  return OwnerEquipmentNotifier(service);
});