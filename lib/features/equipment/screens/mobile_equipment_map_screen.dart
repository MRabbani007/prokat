// features/equipment/screens/mobile_equipment_map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/equipment_map_provider.dart';
import '../widgets/sheets/equipment_browse_sheet.dart';
import '../widgets/sheets/equipment_preview_sheet.dart';
import 'mobile_map_screen.dart';

class MobileEquipmentMapScreen extends ConsumerWidget {
  const MobileEquipmentMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(equipmentMapProvider);

    return Scaffold(
      body: Stack(
        children: [
          // REAL MAP IMPLEMENTATION
          MobileMapScreen(
            mode: MapMode.browseEquipment,
            onEquipmentTapped: (equipment) {
              ref
                  .read(equipmentMapProvider.notifier)
                  .selectEquipment(equipment);
            },
          ),

          // Floating action button (create request)
          // const EquipmentMapFab(),

          // Collapsible browse sheet
          EquipmentBrowseSheet(
            expanded: mapState.isSheetExpanded,
            onExpandChanged: (expanded) {
              ref.read(equipmentMapProvider.notifier).toggleSheet(expanded);
            },
          ),

          // Preview sheet when marker tapped
          if (mapState.selectedEquipment != null)
            EquipmentPreviewSheet(
              equipment: mapState.selectedEquipment!,
              onClose: () {
                ref.read(equipmentMapProvider.notifier).clearSelection();
              },
            ),
        ],
      ),
    );
  }
}
