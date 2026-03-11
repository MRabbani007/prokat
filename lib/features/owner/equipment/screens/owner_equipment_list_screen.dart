import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_provider.dart';
import 'package:prokat/features/owner/equipment/widgets/owner_equipment_card.dart';

class OwnerEquipmentListScreen extends ConsumerStatefulWidget {
  const OwnerEquipmentListScreen({super.key});

  @override
  ConsumerState<OwnerEquipmentListScreen> createState() =>
      _OwnerEquipmentListScreenState();
}

class _OwnerEquipmentListScreenState
    extends ConsumerState<OwnerEquipmentListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        ref.read(ownerEquipmentProvider.notifier).loadEquipment());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerEquipmentProvider);

    return Scaffold(
      // appBar: AppBar(title: const Text("My Equipment")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.equipment.length,
              itemBuilder: (context, index) {
                final equipment = state.equipment[index];

                return OwnerEquipmentCard(equipment: equipment);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/owner/equipment/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}