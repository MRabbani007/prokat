import 'package:flutter/material.dart';
import 'package:prokat/features/map/containers/map_container.dart';
import 'package:prokat/features/map/containers/map_renter_equipment_container.dart';
import '../../../core/router/app_routes.dart';

class MapRenterEquipmentScreen extends StatelessWidget {
  const MapRenterEquipmentScreen({super.key});

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