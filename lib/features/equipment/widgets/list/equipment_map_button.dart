import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EquipmentMapButton extends StatelessWidget {
  const EquipmentMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: IconButton.filledTonal(
        tooltip: "View on map",
        icon: const Icon(Icons.map_outlined),
        onPressed: () => context.push('/search/map'),
      ),
    );
  }
}
