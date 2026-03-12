import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_section_card.dart';
import 'package:prokat/features/owner/equipment/widgets/price_entry_tile.dart';

class PricingSection extends StatelessWidget {
  final List<PriceEntry> prices;
  final VoidCallback onAdd;
  final Function(PriceEntry) onEdit;
  final int maxRates; // Pass the limit here (e.g., 3 for Day, Trip, Week)

  const PricingSection({
    super.key,
    required this.prices,
    required this.onAdd,
    required this.onEdit,
    this.maxRates = 3, // Default limit
  });

  @override
  Widget build(BuildContext context) {
    // Logic: Only allow adding if we haven't reached the limit of rates
    final bool canAddMore = prices.length < maxRates;
print("PRICING SECTION");
print(prices);
    return EquipmentSectionCard(
      title: "Pricing Plans",
      actionIcon: Icons.add_rounded,
      onAction: onAdd,
      isActionEnabled: canAddMore,
      children: [
        if (prices.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "No pricing set yet.", 
              style: TextStyle(fontStyle: FontStyle.italic, )//opacity: 0.6
            ),
          ),
          
        // Use our new separate tile
        ...prices.map((p) => PriceEntryTile(
          price: p,
          onEdit: () => onEdit(p),
        )),

        // Optional: Hint if limit is reached
        if (!canAddMore)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "Maximum pricing options reached.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
