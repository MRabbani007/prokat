import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/equipment_provider.dart';
import '../widgets/list/equipment_list_tile.dart';
import '../widgets/list/equipment_search_bar.dart';
import '../widgets/list/equipment_city_selector.dart';
import '../widgets/list/equipment_map_button.dart';

class EquipmentListScreen extends ConsumerWidget {
  final String? q;
  final String? category;
  final String? city;

  const EquipmentListScreen({super.key, this.q, this.category, this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentsAsync = ref.watch(equipmentsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Equipment"),
        actions: const [EquipmentMapButton()],
      ),
      body: Column(
        children: [
          // Top filters/search section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                EquipmentSearchBar(initialValue: q),
                const SizedBox(height: 8),
                EquipmentCitySelector(city: city ?? "Atyrau"),
              ],
            ),
          ),

          // List
          Expanded(
            child: equipmentsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text("No equipment available"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return EquipmentListTile(
                      equipment: item,
                      onTap: () {
                        context.push('/equipment/${item.id}');
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }
}
