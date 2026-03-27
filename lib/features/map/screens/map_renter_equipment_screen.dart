import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/map/containers/map_container.dart';
import 'package:prokat/features/map/containers/map_renter_equipment_container.dart';
import '../../../core/router/app_routes.dart';

class MapRenterEquipmentScreen extends ConsumerStatefulWidget {
  const MapRenterEquipmentScreen({super.key});

  @override
  ConsumerState<MapRenterEquipmentScreen> createState() =>
      _MapRenterEquipmentScreenState();
}

class _MapRenterEquipmentScreenState
    extends ConsumerState<MapRenterEquipmentScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getRenterEquipment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MapContainer(
      title: "Equipment Map",
      redirectRoute: AppRoutes.searchList,
      redirectLabel: "View equipment list",
      mobileMap: MapRenterEquipmentContainer(),
    );
  }
}