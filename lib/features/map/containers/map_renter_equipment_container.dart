import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/providers/equipment_map_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/sheets/equipment_browse_sheet.dart';
import 'package:prokat/features/equipment/widgets/sheets/equipment_preview_sheet.dart';
import 'package:prokat/features/map/widgets/map_view.dart';

class MapRenterEquipmentContainer extends ConsumerWidget {
  const MapRenterEquipmentContainer({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(equipmentMapProvider);
    final equipmentList = ref.watch(equipmentProvider);
  
    return Scaffold(
      body: Stack(
        children: [
          equipmentList.when(
            data: (equipment) => MyMapView(
              mode: MyMapMode.browseEquipment,
              equipmentList: equipment,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                const Center(child: Text("Failed to load equipment")),
          ),

          EquipmentBrowseSheet(
            expanded: mapState.isSheetExpanded,
            onExpandChanged: (expanded) {
              ref.read(equipmentMapProvider.notifier).toggleSheet(expanded);
            },
          ),

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
