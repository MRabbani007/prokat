import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';

class PriceEntryTile extends StatelessWidget {
  final PriceEntry price;
  final VoidCallback onEdit;

  const PriceEntryTile({super.key, required this.price, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final accent = colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        /// ✅ Use layered surface (NOT light grey / blue)
        color: colorScheme.surfaceContainerHigh,

        borderRadius: BorderRadius.circular(16),

        /// subtle separation inside panel
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          /// PRICE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.priceRate, // e.g. "Per Hour"
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ghostGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${price.price} ₸",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// EDIT ACTION
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_rounded, color: accent, size: 20),
          ),
        ],
      ),
    );
  }
}
