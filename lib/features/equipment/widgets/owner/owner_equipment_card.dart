import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart'; // Add this
import 'package:cached_network_image/cached_network_image.dart'; // Better for fallbacks
import 'package:prokat/features/equipment/models/equipment_model.dart';
class OwnerEquipmentCard extends StatelessWidget {
  final Equipment equipment;

  const OwnerEquipmentCard({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    
    String testImage = "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true ? equipment.imageUrl! : testImage;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28), // Large Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08), // Rim Lighting
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: accentColor.withOpacity(0.2),
                foregroundColor: accentColor,
                icon: Icons.visibility_off_outlined,
                label: 'HIDE',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: const Color(0xFFD97706).withOpacity(0.1),
                foregroundColor: const Color(0xFFD97706),
                icon: Icons.delete_outline_rounded,
                label: 'DELETE',
              ),
            ],
          ),
          child: InkWell(
            onTap: () => context.push('/owner/equipment/${equipment.id}'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Image with Industrial Radius
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16), // Small Item Radius
                      child: CachedNetworkImage(
                        imageUrl: displayUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.black26),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black26,
                          child: const Icon(Icons.bolt, color: ghostGray),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Equipment Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MODEL: ${equipment.model.toUpperCase()}",
                          style: const TextStyle(
                            color: ghostGray,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          equipment.name,
                          style: const TextStyle(
                            color: Colors.white, // Pure White
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  _StatusBadge(status: equipment.status),
                ],
              ),
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
    final Color statusColor = isActive ? const Color(0xFF4E73DF) : const Color(0xFFD97706);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.5),
          width: 1,
        ),
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
