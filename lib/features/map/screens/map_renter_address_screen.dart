import 'package:flutter/material.dart';
import 'package:prokat/features/map/containers/map_container.dart';
import 'package:prokat/features/map/screens/mobile_map_screen.dart';

class MapRenterAddressScreen extends StatelessWidget {
  const MapRenterAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapContainer(
      title: "Choose Address",
      redirectRoute: "/address/list",
      redirectLabel: "Select from list",
      mobileMap: Scaffold(
        body: MobileMapScreen(
          mode: MapMode.pickLocation,
        ),
      ),
    );
  }
}