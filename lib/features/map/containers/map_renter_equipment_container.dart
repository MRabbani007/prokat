import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/providers/equipment_map_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/map/widgets/equipment_browse_sheet.dart';
import 'package:prokat/features/map/widgets/equipment_details_drawer.dart';
import 'package:prokat/features/map/widgets/map_view.dart';

class MapRenterEquipmentContainer extends ConsumerWidget {
  const MapRenterEquipmentContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(equipmentMapProvider);
    final equipmentState = ref.watch(equipmentProvider);

    return Scaffold(
      body: Stack(
        children: [
          equipmentState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : equipmentState.error != null
              ? const Center(child: Text("Failed to load equipment"))
              : MyMapView(
                  mode: MyMapMode.browseEquipment,
                  equipmentList: equipmentState.renterEquipment,
                ),

          if (mapState.selectedEquipment != null)
            EquipmentDetailsDrawer(equipment: mapState.selectedEquipment!),

          if (mapState.selectedEquipment == null)
            EquipmentBrowseSheet(
              // expanded: mapState.isSheetExpanded,
              // onExpandChanged: (expanded) {
              //   ref.read(equipmentMapProvider.notifier).toggleSheet(expanded);
              // },
            ),

          // if (mapState.selectedEquipment != null)
          //   EquipmentPreviewSheet(
          //     equipment: mapState.selectedEquipment!,
          //     onClose: () {
          //       ref.read(equipmentMapProvider.notifier).clearSelection();
          //     },
          //   ),
        ],
      ),
    );
  }
}
