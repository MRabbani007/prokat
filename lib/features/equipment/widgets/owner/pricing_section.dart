import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/features/equipment/widgets/owner/price_entry_tile.dart';

class PricingSection extends StatelessWidget {
  final List<PriceEntry> prices;
  final VoidCallback onAdd;
  final Function(PriceEntry) onEdit;
  final int maxRates;

  const PricingSection({
    super.key,
    required this.prices,
    required this.onAdd,
    required this.onEdit,
    this.maxRates = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final accent = colorScheme.primary;
    final warning = colorScheme.tertiary;

    final bool canAddMore = prices.length < maxRates;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PRICES", style: theme.textTheme.titleLarge),

              if (canAddMore)
                IconButton(
                  onPressed: onAdd,
                  icon: Icon(Icons.add, color: accent, size: 24),
                )
              else
                Icon(Icons.lock, color: Colors.grey, size: 18),
            ],
          ),

          SizedBox(height: 12),

          /// EMPTY STATE
          if (prices.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                "No Prices Listed",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Column(
              children: prices
                  .map((p) => PriceEntryTile(price: p, onEdit: () => onEdit(p)))
                  .toList(),
            ),

          /// FOOTER (MAX REACHED)
          if (!canAddMore)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Text(
                "All Rating Options Listed",
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: ghostGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (canAddMore && prices.isNotEmpty) const SizedBox(height: 16),
        ],
      ),
    );
  }
}
