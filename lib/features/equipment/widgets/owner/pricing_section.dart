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
    const cardColor = Color(0xFF1E2125);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentBlue = Color(0xFF4E73DF);
    const warningAmber = Color(0xFFD97706);

    final bool canAddMore = prices.length < maxRates;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28), // Large Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ), // Rim Light
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Industrial Blue Action
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Prices",
                  style: TextStyle(
                    color: ghostGray,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                if (canAddMore)
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: accentBlue,
                      size: 24,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.lock_clock_outlined,
                      color: ghostGray,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          // Pricing List
          if (prices.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                "NO ACTIVE TARIFFS CONFIGURED",
                style: TextStyle(
                  color: warningAmber,
                  fontSize: 11,
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

          // Industrial Status Footer
          if (!canAddMore)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: const Text(
                "MAXIMUM RATE CAPACITY REACHED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ghostGray,
                  fontSize: 9,
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
