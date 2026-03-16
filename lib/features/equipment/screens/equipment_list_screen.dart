import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/equipment_provider.dart';
import '../widgets/list/equipment_list_tile.dart';
import '../widgets/list/equipment_city_selector.dart';
import '../widgets/list/equipment_map_button.dart';

class EquipmentListScreen extends ConsumerStatefulWidget {
  // Changed to Stateful for search toggle
  final String? q;
  final String? category;
  final String? city;

  const EquipmentListScreen({super.key, this.q, this.category, this.city});

  @override
  ConsumerState<EquipmentListScreen> createState() =>
      _EquipmentListScreenState();
}

class _EquipmentListScreenState extends ConsumerState<EquipmentListScreen> {
  bool _isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    final equipmentsAsync = ref.watch(equipmentProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        // Added SafeArea for mobile notches
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // Action Row
                  Row(
                    children: [
                      const EquipmentCitySelector(),
                      const Spacer(), // Pushes the Map button to the end
                      // Search Toggle Button
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton.filledTonal(
                          onPressed: () => setState(
                            () => _isSearchVisible = !_isSearchVisible,
                          ),
                          icon: Icon(
                            _isSearchVisible ? Icons.close : Icons.search,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const EquipmentMapButton(),
                    ],
                  ),

                  // Expandable Search Bar
                  AnimatedVisibility(
                    visible: _isSearchVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search equipment...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                        onSubmitted: (value) {
                          // Handle search logic here
                        },
                      ),
                    ),
                  ),
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
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => EquipmentListTile(
                      equipment: items[index],
                      onTap: () =>
                          context.push('/equipment/${items[index].id}/book'),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple helper for the search animation
class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: visible
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 250),
    );
  }
}
