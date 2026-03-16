import 'package:flutter/material.dart';
import 'package:prokat/features/map/containers/map_container.dart';
import 'package:prokat/features/map/containers/map_owner_pin_location_container.dart';

class MapOwnerPinLocationScreen extends StatelessWidget {
  final String equipmentId;

  const MapOwnerPinLocationScreen({super.key,required this.equipmentId});

  @override
  Widget build(BuildContext context) {
    return MapContainer(
      title: "Set Equipment Location",
      redirectRoute: "/owner/equipment",
      redirectLabel: "Back to equipment",
      mobileMap: MapOwnerPinLocationContainer(equipmentId:equipmentId),
    );
  }
}