import 'package:flutter/material.dart';

class EquipmentCitySelector extends StatelessWidget {
  final String city;

  const EquipmentCitySelector({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ActionChip(
        avatar: const Icon(Icons.location_on, size: 16, color: Colors.orange),
        label: Text(city),
        onPressed: () {
          // later: open city picker
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
