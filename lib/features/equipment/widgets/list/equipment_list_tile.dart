import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/equipment_model.dart';

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

  Widget _fallback() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_outlined, size: 28, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : testImage;

    /// Hide maintenance equipment for renters
    if (isRenter && equipment.status == "MAINTENANCE") {
      return const SizedBox.shrink();
    }

    final priceEntry = equipment.prices.isNotEmpty
        ? equipment.prices.first
        : null;

    final location = equipment.locations.isNotEmpty
        ? equipment.locations.first
        : null;

    final priceText = priceEntry != null
        ? "${priceEntry.price} / ${priceEntry.priceRate}"
        : "No pricing";

    final locationText = location != null
        ? "${location.city}, ${location.street}"
        : "No location";

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              /// Equipment Image
              SizedBox(
                width: 96,
                height: 72,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: displayUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: displayUrl,
                          fit: BoxFit.cover,
                          memCacheHeight: 300,
                          placeholder: (_, _) => _fallback(),
                          errorWidget: (_, _, _) => _fallback(),
                        )
                      : _fallback(),
                ),
              ),

              const SizedBox(width: 14),

              /// Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    Text(
                      equipment.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Model + Capacity
                    Text(
                      "${equipment.model} • ${equipment.capacity} ${equipment.capacityUnit}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Price + Status
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        _StatusBadge(status: equipment.status),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
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
        color = Colors.green;
        break;
      case "OCCUPIED":
        color = Colors.orange;
        break;
      case "MAINTENANCE":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
