import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';

class EquipmentCard extends ConsumerWidget {
  final Equipment equipment;
  final VoidCallback onTap;

  const EquipmentCard({
    super.key,
    required this.equipment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final notifier = ref.read(favoriteProvider.notifier);
    final bool isFavorite = notifier.isFavorite(equipment.id);

    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";

    final priceEntry = equipment.prices.isNotEmpty
        ? equipment.prices.first
        : null;

    final location = equipment.location;

    final priceRate = priceEntry != null
        ? priceEntry.priceRate.toUpperCase() == "PER_TRIP"
              ? "/ Trip"
              : priceEntry.priceRate.toUpperCase() == "PER_CUBIC_METER"
              ? "/ M3"
              : priceEntry.priceRate.toUpperCase() == "PER_HOUR"
              ? "/ Hour"
              : ""
        : "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// IMAGE + BADGES
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  equipment.imageUrl ?? "",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// STATUS BADGE
              Positioned(
                top: 12,
                left: 12,
                child: _badge(
                  text: equipment.status.toLowerCase() == "available"
                      ? "ONLINE"
                      : "OFFLINE",
                  color: equipment.status.toLowerCase() == "available"
                      ? Colors.green
                      : Colors.grey,
                ),
              ),

              /// DISTANCE BADGE
              Positioned(
                top: 12,
                left: 100,
                child: _badge(
                  text: equipment.location?.city ?? "",
                  color: Colors.black87,
                ),
              ),

              /// PRICE BADGE
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Text(
                        priceEntry != null ? "${priceEntry.price} ₸" : "POA",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        priceRate,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + RATING
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// FAVORITE BUTTON
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ),

                    /// TEXT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipment.owner?.displayName ?? "",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                equipment.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 4),

                              Text(
                                equipment.model,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Text(
                                equipment.capacity,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(width: 4),

                              Text(
                                equipment.capacityUnit,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// RATING
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 255, 205, 57),
                          size: 32,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          "4.5",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// RENT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color.fromARGB(255, 255, 242, 200),
                    ),
                    child: const Text(
                      "RESERVE NOW",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// REUSABLE BADGE
  Widget _badge({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
