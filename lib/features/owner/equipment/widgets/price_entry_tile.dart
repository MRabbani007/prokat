import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/features/owner/equipment/constants/price_rate_options.dart';

class PriceEntryTile extends StatelessWidget {
  final PriceEntry price;
  final VoidCallback onEdit;

  const PriceEntryTile({super.key, required this.price, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.sell_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          "${price.price} ₸",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          priceRateOptions
              .firstWhere(
                (o) => o.value == price.priceRate.toUpperCase(),
                orElse: () =>
                    const PriceRateOption(value: "", label: "Unknown"),
              )
              .label,
        ),
        trailing: IconButton.filledTonal(
          icon: const Icon(Icons.edit_rounded, size: 16),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
