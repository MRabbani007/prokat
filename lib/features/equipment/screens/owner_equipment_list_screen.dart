import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/owner/owner_equipment_card.dart';

class OwnerEquipmentListScreen extends ConsumerStatefulWidget {
  const OwnerEquipmentListScreen({super.key});

  @override
  ConsumerState<OwnerEquipmentListScreen> createState() =>
      _OwnerEquipmentListScreenState();
}

class _OwnerEquipmentListScreenState
    extends ConsumerState<OwnerEquipmentListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getOwnerEquipment();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Refetch when coming back to the page
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(equipmentProvider.notifier).getOwnerEquipment();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Industrial Midnight Palette
    const bgColor = Color(0xFF121417);
    const accentColor = Color(0xFF4E73DF); // Industrial Blue
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    final state = ref.watch(equipmentProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            // 1. Management Header Style
            PageHeader(title: "My Equipment"),

            // Subtle "Owner Mode" Indicator
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            //   child: Row(
            //     children: [
            //       Container(
            //         width: 8,
            //         height: 8,
            //         decoration: const BoxDecoration(
            //           color: Color(0xFFD97706), // Amber/Warning
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       Text(
            //         "ADMINISTRATIVE ACCESS ACTIVE",
            //         style: TextStyle(
            //           color: ghostGray,
            //           fontSize: 10,
            //           fontWeight: FontWeight.bold,
            //           letterSpacing: 1.5,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // 2. Scrollable Content
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: accentColor),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        10,
                        20,
                        90,
                      ), // Extra bottom padding for the bar
                      itemCount: state.ownerEquipment.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: OwnerEquipmentCard(
                            equipment: state.ownerEquipment[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // 3. Fixed Bottom Action Bar (Replaces FAB)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          // The "Rim Light" top border to separate from the list
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TOTAL ASSETS",
                  style: TextStyle(
                    color: ghostGray,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${state.ownerEquipment.length} UNITS",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // The "Add Equipment" Button
            ElevatedButton.icon(
              onPressed: () => context.push('/owner/equipment/create'),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text("ADD EQUIPMENT"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Small Item Radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
