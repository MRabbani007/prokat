import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';

class OwnerEquipmentCard extends ConsumerWidget {
  final Equipment equipment;

  const OwnerEquipmentCard({super.key, required this.equipment});

  String _formatPriceRate(String? rate) {
    switch (rate?.toUpperCase()) {
      case "PER_TRIP":
        return "/ Trip";
      case "PER_CUBIC_METER":
        return "/ M3";
      case "PER_HOUR":
        return "/ Hour";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Theme-based colors
    final accentColor = theme.primaryColor;
    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.5);

    final locationText = equipment.location?.city ?? "No location set";
    final priceEntry = equipment.prices.firstOrNull;
    final priceDisplay = priceEntry != null
        ? "${priceEntry.price} ${_formatPriceRate(priceEntry.priceRate)}"
        : "No Price Set";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TOP ROW: Image, Info, and Toggle
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(equipment.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        equipment.name,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "MODEL: ${equipment.model.toUpperCase()}",
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      _StatusBadge(status: equipment.status),
                    ],
                  ),
                ),

                // Dedicated Edit Button
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(equipmentProvider.notifier)
                        .selectEditEquipment(equipment);
                    context.push('/owner/equipment/${equipment.id}');
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),

            // BOTTOM ROW: Location, Price, and Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: ghostGray),
                          const SizedBox(width: 4),
                          Text(locationText, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        priceDisplay,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Online Toggle
                _onlineToggle(context, ref),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url ?? "",
        width: 110,
        height: 70,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _onlineToggle(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "ONLINE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: equipment.isVisible
                ? const Color.fromARGB(255, 0, 160, 5)
                : const Color.fromARGB(255, 218, 0, 0),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: equipment.isVisible,
            activeThumbColor: const Color(0xFF4E73DF),
            onChanged: (val) async {
              print(val);
              await ref
                  .read(equipmentProvider.notifier)
                  .updateVisibilityStatus(equipment.id, val, equipment.status);
            },
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == 'available';
    final Color statusColor = isActive
        ? const Color.fromARGB(255, 247, 90, 0)
        : const Color.fromARGB(255, 24, 143, 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white, // White background to show the shadow
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: statusColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
