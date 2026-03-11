// features/equipment/widgets/sheets/equipment_browse_sheet.dart

import 'package:flutter/material.dart';

class EquipmentBrowseSheet extends StatelessWidget {
  final bool expanded;
  final ValueChanged<bool> onExpandChanged;

  const EquipmentBrowseSheet({
    super.key,
    required this.expanded,
    required this.onExpandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.45,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              const Center(child: Icon(Icons.drag_handle)),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Current location"),
                subtitle: const Text("Atyrau, Kazakhstan"),
              ),
              const Divider(),
              // capacity chips placeholder
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: Text("10t"), selected: false),
                  ChoiceChip(label: Text("20t"), selected: false),
                  ChoiceChip(label: Text("30t"), selected: false),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/requests/create');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create request"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
