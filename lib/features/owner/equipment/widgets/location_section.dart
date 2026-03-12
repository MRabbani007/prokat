import 'package:flutter/material.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_section_card.dart';

class LocationSection extends StatelessWidget {
  final String? location;
  final VoidCallback onAction; // Renamed to match our modern card

  const LocationSection({
    super.key,
    required this.location,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = location != null && location!.isNotEmpty;

    return EquipmentSectionCard(
      title: "Base Location",
      actionIcon: hasLocation ? Icons.map_rounded : Icons.add_location_alt_rounded,
      onAction: onAction,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                hasLocation ? Icons.location_on_rounded : Icons.location_off_rounded,
                color: hasLocation ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  location ?? "No location assigned to this equipment",
                  style: TextStyle(
                    fontWeight: hasLocation ? FontWeight.w600 : FontWeight.normal,
                    color: hasLocation ? null : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}