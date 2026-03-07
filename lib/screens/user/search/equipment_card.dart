// In your search page (or main page), replace the 'EquipmentListTile' with this:

import 'package:flutter/material.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';

class EquipmentCard extends StatelessWidget {
  final EquipmentModel item;
  final VoidCallback onTap;

  const EquipmentCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        // Use InkWell for tap functionality
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. Main Photo Section ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                item.imageUrl,
                height: 180.0,
                fit: BoxFit.cover,
                // Add a placeholder asset for when the network image fails
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            // --- 2. Details and Price Section ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.price.toString(),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Model: ${item.model}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // --- 3. Key Info Row (Location, Capacity) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(Icons.location_on, item.location),
                      _buildInfoChip(
                        Icons.straighten,
                        item.capacity.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // --- 4. Owner Info ---
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        child: Icon(Icons.person, size: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Owner: ${item.owner}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.0, color: Colors.orange),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: const TextStyle(fontSize: 13.0, color: Colors.black87),
        ),
      ],
    );
  }
}
