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

    final cardColor = colorScheme.surfaceContainerHighest;
    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final accent = colorScheme.primary;
    final warning = colorScheme.tertiary;

    final bool canAddMore = prices.length < maxRates;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PRICES",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: ghostGray,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                if (canAddMore)
                  IconButton(
                    onPressed: onAdd,
                    icon: Icon(Icons.add_box_rounded, color: accent, size: 24),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.lock_clock_outlined,
                      color: ghostGray,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          /// EMPTY STATE
          if (prices.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                "NO ACTIVE TARIFFS CONFIGURED",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: prices
                    .map(
                      (p) => PriceEntryTile(price: p, onEdit: () => onEdit(p)),
                    )
                    .toList(),
              ),
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
                "MAXIMUM RATE CAPACITY REACHED",
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
