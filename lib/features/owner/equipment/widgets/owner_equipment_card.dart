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
    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true ? equipment.imageUrl! : testImage;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Slidable(
        // Swipe Right (Start to End)
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // TODO: Logic for View/Hide toggle
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View/Hide',
            ),
          ],
        ),
        // Swipe Left (End to Start)
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                // TODO: Delete logic
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // GO_ROUTER: Navigation with parameter
            context.push('/owner/equipment/${equipment.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Image with Fallback and Loading state
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: displayUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
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
                        equipment.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        equipment.model,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.toLowerCase() == 'active' ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: status.toLowerCase() == 'active' ? Colors.green : Colors.orange,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: status.toLowerCase() == 'active' ? Colors.green[800] : Colors.orange[800],
        ),
      ),
    );
  }
}
