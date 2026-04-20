import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';
import 'package:go_router/go_router.dart';

class FavoriteItemTile extends ConsumerWidget {
  final Equipment equipment;

  const FavoriteItemTile({super.key, required this.equipment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watch the favorite status to ensure UI updates immediately
    final isFavorite =
        ref.watch(
          favoriteProvider.select(
            (s) => s.favoritesIds?.contains(equipment.id),
          ),
        ) ??
        false;

    final bookingNotifier = ref.read(bookingProvider.notifier);

    final priceEntry = equipment.prices.isNotEmpty
        ? equipment.prices.first
        : null;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SECTION
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.network(
                  equipment.imageUrl ?? "",
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 110,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              // Compact Favorite Toggle
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    ref
                        .read(favoriteProvider.notifier)
                        .toggleFavorite(equipment.id);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isFavorite ? Colors.red : Colors.grey,
                    elevation: 2,
                  ),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          /// INFO SECTION
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${equipment.name} ${equipment.model}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  priceEntry != null ? "${priceEntry.price} ₸" : "POA",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          /// ACTION BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: FilledButton(
                onPressed: () {
                  bookingNotifier.selectEquipment(equipment);
                  context.push('/equipment/${equipment.id}/book');
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Open", style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
