import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/equipment_model.dart'; // Adjust path

class EquipmentListTile extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onTap;
  final bool isRenter;

  const EquipmentListTile({
    super.key,
    required this.equipment,
    required this.onTap,
    this.isRenter = false,
  });

  // Industrial Fallback for missing images
  Widget _fallback() {
    return Container(
      color: Colors.white.withValues(alpha: 0.03),
      child: Center(
        child: Icon(
          Icons.precision_manufacturing_rounded,
          size: 28,
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);

    // Hardcoded test image logic from your snippet
    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : testImage;

    if (isRenter && equipment.status == "MAINTENANCE") {
      return const SizedBox.shrink();
    }

    final priceEntry = equipment.prices.isNotEmpty
        ? equipment.prices.first
        : null;
    final location = equipment.location;

    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Small gap if used in ListView
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                /// 1. IMAGE BOX
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: displayUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _fallback(),
                      errorWidget: (_, _, _) => _fallback(),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// 2. CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status & Category Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatusBadge(status: equipment.status),
                          Text(
                            "ID: ${equipment.id.split('-').last.toUpperCase()}",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.15),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Name
                      Text(
                        equipment.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Sub-specs
                      Text(
                        "${equipment.model} • ${equipment.capacity} ${equipment.capacityUnit}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Location & Price Footer
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location != null ? "${location.city}" : "Global",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            priceEntry != null
                                ? "${priceEntry.price} ₸"
                                : "POA",
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
    Color color;
    switch (status) {
      case "AVAILABLE":
        color = Colors.greenAccent;
        break;
      case "OCCUPIED":
        color = Colors.orangeAccent;
        break;
      case "MAINTENANCE":
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
