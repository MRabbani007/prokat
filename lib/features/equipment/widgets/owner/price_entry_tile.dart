import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/core/constants/price_rate_options.dart';

class PriceEntryTile extends StatelessWidget {
  final PriceEntry price;
  final VoidCallback onEdit;

  const PriceEntryTile({super.key, required this.price, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentBlue = Color(0xFF4E73DF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2), // Darker inset for the tile
        borderRadius: BorderRadius.circular(16), // Small Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05), // Subtle Rim Light
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            // Industrial Icon Indicator
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.payments_outlined,
                size: 20,
                color: accentBlue,
              ),
            ),
            const SizedBox(width: 16),

            // Pricing Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priceRateOptions
                        .firstWhere(
                          (o) => o.value == price.priceRate.toUpperCase(),
                          orElse: () => const PriceRateOption(
                            value: "",
                            label: "UNKNOWN RATE",
                          ),
                        )
                        .label
                        .toUpperCase(),
                    style: const TextStyle(
                      color: ghostGray,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${price.price} ₸",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily:
                          'monospace', // Gives it a technical/receipt feel
                    ),
                  ),
                ],
              ),
            ),

            // Edit Action
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.tune_rounded, color: ghostGray, size: 20),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
