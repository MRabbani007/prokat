import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/equipment.dart';
import '../providers/equipment_repository_provider.dart';

class EquipmentController extends StateNotifier<AsyncValue<List<Equipment>>> {
  final Ref ref;

  EquipmentController(this.ref) : super(const AsyncValue.loading());

  Future<void> loadEquipment() async {
    state = const AsyncValue.loading();

    final repo = ref.read(equipmentRepositoryProvider);

    final response = await repo.getEquipment();

    if (response.success) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(response.message!, StackTrace.current);
    }
  }
}

final equipmentControllerProvider =
    StateNotifierProvider<EquipmentController, AsyncValue<List<Equipment>>>(
      (ref) => EquipmentController(ref),
    );
