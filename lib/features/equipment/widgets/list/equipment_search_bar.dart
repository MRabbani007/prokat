import 'package:flutter/material.dart';

class EquipmentSearchBar extends StatelessWidget {
  final String? initialValue;

  const EquipmentSearchBar({super.key, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        hintText: "Search equipment...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (value) {
        // later: trigger provider filter
      },
    );
  }
}
