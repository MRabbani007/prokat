import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/equipment_controller.dart';

class EquipmentPage extends ConsumerWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentState = ref.watch(equipmentControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Equipment")),
      body: equipmentState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (equipment) {
          return ListView.builder(
            itemCount: equipment.length,
            itemBuilder: (context, index) {
              final item = equipment[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text("${item.price} ₸"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(equipmentControllerProvider.notifier).loadEquipment();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
