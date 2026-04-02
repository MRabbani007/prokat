import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Add this
import 'package:cached_network_image/cached_network_image.dart'; // Better for fallbacks
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';

class OwnerEquipmentCard extends ConsumerWidget {
  final Equipment equipment;

  const OwnerEquipmentCard({super.key, required this.equipment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    final equipmentNotifier = ref.read(equipmentProvider.notifier);

    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";

    final String locationText =
        equipment.location?.street ??
        equipment.location?.city ??
        "No location set";

    final String priceDisplay = equipment.prices.isNotEmpty
        ? "\$${equipment.prices[0].price}/${equipment.prices[0].priceRate}"
        : "No price set";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            ref.read(equipmentProvider.notifier).selectEditEquipment(equipment);
            context.push('/owner/equipment/${equipment.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // FIRST ROW: Image + Name/Model + Toggle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: displayUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipment.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "MODEL: ${equipment.model.toUpperCase()}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 230, 230, 230),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Availability Toggle in top right
                    Column(
                      children: [
                        const Text(
                          "AVAILABLE",
                          style: TextStyle(
                            color: Color.fromARGB(255, 230, 230, 230),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: equipment.isVisible,
                          onChanged: (val) async {
                            /* Toggle Logic */
                            final res = await equipmentNotifier
                                .updateVisibilityStatus(
                                  equipment.id,
                                  val,
                                  equipment.status,
                                );
                            if (res == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Equipment Updated"),
                                ),
                              );
                            }
                          },
                          activeColor: accentColor,
                        ),
                      ],
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Colors.white10, height: 1),
                ),

                // SECOND ROW: Status + Location/Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusBadge(status: equipment.status),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: ghostGray,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  locationText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            priceDisplay,
                            style: const TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == 'active';
    final Color statusColor = isActive
        ? const Color(0xFF4E73DF)
        : const Color(0xFFD97706);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: statusColor,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
